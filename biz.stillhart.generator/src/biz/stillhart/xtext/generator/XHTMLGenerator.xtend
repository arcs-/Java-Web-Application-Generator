package biz.stillhart.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import biz.stillhart.xtext.util.GModelTranslater

/**
 * Generates XHTML templates based on gModel
 * 
 * @author Patrick Stillhart
 */
class XHTMLGenerator {

	Desc desc = null

	def generateXHTML(Resource resource, IFileSystemAccess2 fsa) {

		desc = resource.allContents.filter(Desc).head

		// generate files
		for (e : resource.allContents.toIterable.filter(Form)) {

			val path = desc.name + "-web/src/main/webapp/" + e.name.toLowerCase + ".xhtml"

			fsa.generateFile(path, e.compileList)

		}
		
		// generate navigation
		val path = desc.name + "-web/src/main/webapp/template/navi.xhtml"
		fsa.generateFile(path, compileNav(resource))
		

	}

	def compileList(Form e) '''
		«IF false/* intent enforce */»«ENDIF»
		<?xml version='1.0' encoding='UTF-8' ?>
		<!DOCTYPE html>
		<html xmlns="http://www.w3.org/1999/xhtml"
		      xmlns:b="http://bootsfaces.net/ui"
		      xmlns:f="http://java.sun.com/jsf/core"
		      xmlns:h="http://java.sun.com/jsf/html"
			  xmlns:ui="http://java.sun.com/jsf/facelets">
		
		<ui:composition template="template/layout.xhtml">
		
		<!-- Table -->
		
		  <ui:define name="title">
		      «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()» Editor
		  </ui:define>
		  
		    <ui:define name="content">
		    
		    	<h1>«e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»</h1><br></br>
		    	
				<style>#editableEntryTable table, #editableEntryTable table input {width:100%}</style>
		    	
		    	 <h:form id="editableEntryTable">
		    	 <b:dataTable value="#{«e.name.toFirstLower»Bean.«e.name.toFirstLower»s}" var="entry">
		    	     <b:dataTableColumn value="#{entry.id}" label="Id"/>
		    		«FOR f : e.fields»
		    			«if(f.type == DataType.BOOLEAN) f.compileBooleanListEntry else f.compileTextListEntry»
		    		«ENDFOR»
		    		<b:dataTableColumn label="" orderable="false" searchable="false" style="white-space:nowrap">
		            	<b:commandButton value="edit" icon="pencil" ajax="true" update="editableEntryTable messages" onclick="ajax:«e.name.toFirstLower»Bean.update(entry)" rendered="#{!entry.editable}" />
		            	<b:commandButton value="save" icon="pencil" ajax="true" update="editableEntryTable messages" onclick="ajax:«e.name.toFirstLower»Bean.update(entry)" rendered="#{entry.editable}" />
		            	
		            	&#160;<b:commandButton value="delete" icon="trash" ajax="true" update="editableEntryTable messages" onclick="ajax:«e.name.toFirstLower»Bean.delete(entry)" />
		     	   </b:dataTableColumn>
		     	    
		     	</b:dataTable>
		    </h:form>
		    
		
		<!-- MODAL -->
				
			<h:form id="addForm">
				<b:modal title="Add a «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»" styleClass="addModal">
				
					<div style="width:100%">
					«FOR f : e.fields»
						«if(f.type == DataType.BOOLEAN) compileNewBooleanForm(e,f) else compileNewTextForm(e,f)»
					«ENDFOR»
			   		</div>
				 	
				    <f:facet name="footer">
				    
				        <b:button value="Cancel" dismiss="modal" onclick="return false;"/>
				        <b:commandButton value="Add" icon="plus" look="success" dismiss="modal" ajax="true" update="editableEntryTable addForm messages" onclick="$('.modal-backdrop.in').remove();ajax:«e.name.toFirstLower»Bean.create()"/>
				        
				    </f:facet>
				    
				</b:modal>
		    </h:form>
		    
		    <b:button value="New «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»" icon="plus" onclick="$('.addModal').modal();return false;"></b:button>
		      
		    </ui:define>
		    
		  </ui:composition>
		  
		  </html>
	'''
	
	/*
	 * Add form
	 */
	def compileNewTextForm(Form e, Field f) '''
		<b:inputText value="#{«e.name.toFirstLower»Bean.«e.name.toFirstLower».«f.name.toLowerCase»}" renderLabel="true" label="«f.name.toFirstUpper»" «GModelTranslater.fieldToHTMLFilter(f)»/>
	'''
	
	def compileNewBooleanForm(Form e, Field f) '''
		<b:selectBooleanCheckbox value="#{«e.name.toFirstLower»Bean.«e.name.toFirstLower».«f.name.toLowerCase»}" caption="&#160;«f.name.toFirstUpper»" style="width:30px;height:15px"/>
	'''

	/*
	 * List
	 */
	def compileTextListEntry(Field f) '''
		<b:dataTableColumn label="«f.name.toFirstUpper»" data-type="#{entry.editable ? 'text' : 'string'}" style="width:50vw">
			<h:outputText value="#{entry.«f.name.toLowerCase»}" rendered="#{!entry.editable}" />
			<b:inputText value="#{entry.«f.name.toLowerCase»}" rendered="#{entry.editable}" «GModelTranslater.fieldToHTMLFilter(f)» />
		</b:dataTableColumn>
	'''
	
	def compileBooleanListEntry(Field f) '''
		<b:dataTableColumn label="«f.name.toFirstUpper»" data-type="boolean" style="width:50vw">
			<b:selectBooleanCheckbox value="#{entry.«f.name.toLowerCase»}" rendered="#{!entry.editable}" onclick="return false;" style="width:30px;height:15px"/>
			<b:selectBooleanCheckbox value="#{entry.«f.name.toLowerCase»}" rendered="#{entry.editable}" style="width:30px;height:15px"/>
		</b:dataTableColumn>
	'''
	
	/*
	 * Navigation
	 */
	def compileNav(Resource resource) '''
		<?xml version='1.0' encoding='UTF-8' ?>
		<!DOCTYPE html>
		<html xmlns="http://www.w3.org/1999/xhtml"
		      xmlns:b="http://bootsfaces.net/ui"
		      xmlns:h="http://java.sun.com/jsf/html"
			  xmlns:ui="http://java.sun.com/jsf/facelets">
		
			<b:navBar brand="«desc.name»" inverse="true" brand-href="/«desc.name»" style="border-radius:0">
				<b:navbarLinks>
					«FOR f : resource.allContents.toIterable.filter(Form)»
						<b:navLink value="«f.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»" href="/«desc.name»/«f.name.toLowerCase».xhtml"></b:navLink>
					«ENDFOR»
				</b:navbarLinks>
			</b:navBar>
		
		</html>
	'''
	
	

}
