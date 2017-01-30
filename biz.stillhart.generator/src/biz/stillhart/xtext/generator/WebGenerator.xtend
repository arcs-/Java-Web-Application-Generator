package biz.stillhart.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.util.Calendar

/**
 * Generates Web Beans based on gModel ( needs XHTMLgenerator.xtend )
 * 
 * @author Patrick Stillhart
 */
class WebGenerator {
	
	Desc desc = null
	
	def generateWeb(Resource resource, IFileSystemAccess2 fsa) {
		
		desc = resource.allContents.filter(Desc).head
		
		// generate interfaces
		for (e : resource.allContents.toIterable.filter(Form)) {
			
			val path = desc.name 
						+ "-web/src/main/java/"
						+ desc.domain.replaceAll("\\.", "/")
						+ "/web/"
						+ e.name.toFirstUpper
						+ "Bean.java"
						
			fsa.generateFile(path, e.compileBean)
			
		}
		
	}
	
	def compileBean(Form e) '''
		«IF false/* intent enforce */»«ENDIF»
		package «desc.domain».ejb.beans;
		
		import javax.annotation.Generated;
		
		import javax.annotation.PostConstruct;
		import javax.ejb.EJB;
		import javax.faces.bean.ManagedBean;
		import javax.faces.bean.ViewScoped;
		
		import «desc.domain».jpa.«e.name»;
		import «desc.domain».ejb.beans.«e.name»ServiceBean;
		
		import biz.stillhart.generator.util.MessageHelper;
		
		import java.util.List;
		
		/*
			This file has been automatically generated on «Calendar.getInstance().getTime()»,
			you may not edit this file but rather extend it
		*/
		
		/**
		 *  Web Bean for «e.name.toFirstUpper»
		 */
		@ManagedBean
		@ViewScoped
		@Generated(value = { "http://www.stillhart.biz/xtext/Generator" })
		public class «e.name.toFirstUpper»Bean {
			
			@EJB
			private «e.name.toFirstUpper»ServiceBean «e.name.toFirstLower»Service;
			
			private «e.name.toFirstUpper» «e.name.toFirstLower»;
			private List<«e.name.toFirstUpper»> «e.name.toFirstLower»s;
			
			/**
			 * Constructor for this class
			 */
			@PostConstruct
			public void init() {
				«e.name.toFirstLower» = new «e.name.toFirstUpper»();
				«e.name.toFirstLower»s = «e.name.toFirstLower»Service.readAll();
			}
			
			/**
			 * @return all entries
			 */
			public List<«e.name»> get«e.name.toFirstUpper»s() {
				return «e.name.toFirstLower»s;
			}
			
			/**
			 * @return the new entry
			 */
			public «e.name.toFirstUpper» get«e.name.toFirstUpper»() {
				return «e.name.toFirstLower»;
			}
			
			/**
			 * set the new entry
			 */
			public void set«e.name.toFirstUpper»(«e.name.toFirstUpper» «e.name.toFirstLower») {
				this.«e.name.toFirstLower» = «e.name.toFirstLower»;
			}
			
			/**
			 * adds the new entry
			 */
			public void create() {
				«e.name.toFirstLower»Service.create(«e.name.toFirstLower»);
				MessageHelper.createInfo("Added a new «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»");
				init();
			}
			
			/**
			 * updates an entry
			 */
			public void update(«e.name.toFirstUpper» «e.name.toFirstLower») {
				if(«e.name.toFirstLower».isEditable()) {
					«e.name.toFirstLower»Service.update(«e.name.toFirstLower»);
					MessageHelper.createInfo("Updated «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»");
				}
				«e.name.toFirstLower».edit();
			}
			
			/**
			 * removes an entry
			 */
			public void delete(«e.name.toFirstUpper» «e.name.toFirstLower») {
				«e.name.toFirstLower»Service.delete(«e.name.toFirstLower».getId());
				MessageHelper.createInfo("Removed «e.name.toFirstUpper.replaceAll("([A-Z])", " $1").trim()»");
				init();
			}
			
		}
	'''

}
