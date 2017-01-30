See: https://gist.github.com/arcs-/5666f3120cee0282475ad224043f5cff

Web Application Generator
===================

This is a generator that will allow you to easly create complex JSF applications. Using the JPA, EJBs and JSF with Bootsfaces.

----------

> **Requirements:**

> - Eclipse ( with Maven )
> - Glassfish 4.* ( or any other Java webserver with Java EE libraries ) and a JDBC pool
> - A JPA compatible Database ( e.g. Mysql )

## <i class="icon-file"></i> Import the Generator

The document panel is accessible using the <i class="icon-folder-open"></i> button in the navigation bar. You can create a new document by clicking <i class="icon-file"></i> **New document** in the document panel.

## <i class="icon-pencil"></i> Write the Script
```
version 1.0.0
name TheAmazingApp
domain biz.stillhart.amazing

form Customer
	! firstname string
	! lastname string
	street string  
	city string
	zipcode int
	is_rich boolean 
```
Create a new file in the `src` folder with the `.gmodel` extension. The script is space sensitive, like in Phyton you have to intend. The Attributes are seperated by spaces and linebreaks.

All scripts require a head with `version`, `name` and `domain`. Optionally you may specfiiy a `database`, the default for would be `java:comp/DefaultDataSource`.


```json
form Formname Databasename
	! a_required_string string
	! a_required_int int
	a_long long 
	a_boolean boolean
	a_char char
```
After the head multiple forms follow. A form defines the page and table that will be generated. The name can be followed by a name for the table, defaults to a lowercase of the name.

Attributes start with a `!` when the are manadory to enter in the UI (`not null` on the DB). Then comes the name followed by the Datatype. 

##### DataTypes
`char | string | int | long | boolean`




## <i class="icon-refresh"></i> Generation
The generator will do its thing as sone as you save. All files will be compiled into `src-gen`.
Wait about a second (on a really slow computer a bit more).

Then refresh this folder and right click on the last file `pom.xml`. In the context menue click `run as` -> `6 Maven install`. This will take another second and you may want to refresh again.

In `...-app` folder under `target` should be a `.ear` file, which can easly deployed on the server.

> **Notes**

> Dueto the nature of the compiler, you have to delete this folder whenever you remove a form.

## <i class="icon-bug"></i> "It's not working"

 - Make sure all the requirements are met. Do all server run, does the JDBC ping work and is the URL correct?
 - There shouldn't be any warnings (or errors) in the `.gmodel`
 - Dues the Database exist and is it empty?

## <i class="icon-file"></i> Example
```json
version 1.0.0
name BbcBank
domain ch.bbc.uek223 

form Customer aTable
	! firstname string
	! lastname string
	title string
	street string  
	city string
	zipcode int
	is_rich boolean 

form Account
	! iban string
	! balance long
	overdraft long
	active boolean

form Transaction
	type char
	text string
	amount long
```