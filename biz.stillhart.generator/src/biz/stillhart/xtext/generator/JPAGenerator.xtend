package biz.stillhart.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import biz.stillhart.xtext.util.GModelTranslater
import java.util.Calendar

/**
 * Generates JPAs based on gModel
 * 
 * @author Patrick Stillhart
 */
class JPAGenerator {
	
	Desc desc = null
	
	def generateJPA(Resource resource, IFileSystemAccess2 fsa) {
		
		desc = resource.allContents.filter(Desc).head
		
		// generate files
		for (e : resource.allContents.toIterable.filter(Form)) {
			
			val path = desc.name 
						+ "-jpa/src/main/java/"
						+ desc.domain.replaceAll("\\.", "/")
						+ "/jpa/"
						+ e.name.toFirstUpper
						+ ".java"
						
			fsa.generateFile(path, e.compile)
			
		}
		
		val path = desc.name 
						+ "-jpa/src/main/java/"
						+ desc.domain.replaceAll("\\.", "/")
						+ "/jpa/AbstractBaseEntity.java"
						
			fsa.generateFile(path, abstractBaseEntity())
		
	}
	
	def compile(Form e) '''
		«IF false/* intent enforce */»«ENDIF»
		package «desc.domain».jpa;

		import javax.persistence.*;
		import javax.validation.constraints.*;
		
		import javax.annotation.Generated;
		
		/*
			This file has been automatically generated on «Calendar.getInstance().getTime()»,
			you may not edit this file but rather extend it
		*/
		
		@Entity
		@Table(name = "«if(null == e.table) e.name.toLowerCase else e.table»")
		@Generated(value = { "http://www.stillhart.biz/xtext/Generator" })
		public class «e.name.toFirstUpper» extends AbstractBaseEntity {

		    «FOR f : e.fields»
		    	«f.compileDeclaration»
		    «ENDFOR»
		
		    «FOR f : e.fields»
		    	«f.compileGetterAndSetter»
		    «ENDFOR»
		    
		}
	'''
	def compileDeclaration(Field f) '''
	«GModelTranslater.fieldToAnnotationFilter(f)»
	@Column(name = "`«f.name.toLowerCase»`"«if (f.required == "!") println(', nullable=false')»)
	private «GModelTranslater.dataTypeToJava(f.type)» «f.name.toLowerCase»;
	
	'''

	def compileGetterAndSetter(Field f) '''
	public «GModelTranslater.dataTypeToJava(f.type)» get«f.name.toFirstUpper»() {
		return «f.name.toLowerCase»;
	}
	
	public void set«f.name.toFirstUpper»(«GModelTranslater.dataTypeToJava(f.type)» «f.name.toLowerCase») {
		this.«f.name.toLowerCase» = «f.name.toLowerCase»;
	}
	
	'''
	
	def abstractBaseEntity() '''
		«IF false/* intent enforce */»«ENDIF»
		package «desc.domain».jpa;
		
		import javax.persistence.*;
		import javax.annotation.Generated;
		
		@MappedSuperclass
		@Generated(value = { "http://www.stillhart.biz/xtext/Generator" })
		public class AbstractBaseEntity {
		
			@Transient
			private boolean editable = false;
		
		    @Id
		    @GeneratedValue(strategy = GenerationType.IDENTITY)
		    @Column(name = "id")
		    private long id;
		    
			public boolean isEditable() {
				return editable;	
			}
		   	
			public void edit() {
				this.editable = !editable;
			}
		
		    public long getId() {
		        return id;
		    }
		
		    public void setId(long id) {
		        this.id = id;
		    }
		
		}
	'''
	
}
