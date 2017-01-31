package biz.stillhart.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import biz.stillhart.xtext.util.GModelTranslater
import java.util.Calendar

/**
 * Generates EJBs based on gModel
 * 
 * @author Patrick Stillhart
 */
class EJBGenerator {
	
	Desc desc = null
	
	def generateEJB(Resource resource, IFileSystemAccess2 fsa) {
		
		desc = resource.allContents.filter(Desc).head
		
		// generate interfaces
		for (e : resource.allContents.toIterable.filter(Form)) {
			
			val path = desc.name 
						+ "-ejb/src/main/java/"
						+ desc.domain.replaceAll("\\.", "/")
						+ "/ejb/interfaces/"
						+ e.name.toFirstUpper
						+ "Service.java"
						
			fsa.generateFile(path, e.compileInterface)
			
		}
		
		// generate beans
		for (e : resource.allContents.toIterable.filter(Form)) {
			
			val path = desc.name 
						+ "-ejb/src/main/java/"
						+ desc.domain.replaceAll("\\.", "/")
						+ "/ejb/beans/"
						+ e.name.toFirstUpper
						+ "ServiceBean.java"
						
			fsa.generateFile(path, e.compileBean)
			
		}
		
	}
	
	/* ---------------------------------------------------------------------------- *
	 * Interface                                                                    *
	 * ---------------------------------------------------------------------------- */
	
	def compileInterface(Form e) '''
		«IF false/* intent enforce */»«ENDIF»
		package «desc.domain».ejb.interfaces;
		
		import java.util.List;
		
		import javax.annotation.Generated;
		
		import «desc.domain».jpa.«e.name»;
		
		/*
			This file has been automatically generated on «Calendar.getInstance().getTime()»,
			you may not edit this file but rather extend it
		*/
		
		@Generated(value = { "http://www.stillhart.biz/xtext/Generator" })
		public interface «e.name.toFirstUpper»Service {
		
			/**
			 * Creates a new «e.name.toFirstUpper»
			 * @param customer the customer
			 */
			public void create(«e.name.toFirstUpper» «e.name.toLowerCase»);
		
			/**
			 * Loads a «e.name.toFirstUpper» by it's Id
			 * @param id the id to search for
			 * @return the «e.name.toFirstUpper»
			 */
			public «e.name.toFirstUpper» read(long id);

			/**
			 * Loads all «e.name.toFirstUpper»s
			 * @return all the «e.name.toFirstUpper»s
			 */
			public List<«e.name.toFirstUpper»> readAll();
		
			/**
			 * Updates a «e.name.toFirstUpper»
			 * @param «e.name.toFirstUpper» the «e.name.toFirstUpper» with updated data
			 */
			public void update(«e.name.toFirstUpper» «e.name.toLowerCase»);
		
			/**
			 * Deletes a «e.name.toFirstUpper» 
			 * @param id the Id to remove
			 */
			public void delete(long id);
		
		}
	'''

	def compileInterfaceGetterAndSetter(Field f) '''
	public «GModelTranslater.dataTypeToJava(f.type)» get«f.name.toFirstUpper»s();
	
	public void set«f.name.toFirstUpper»(«GModelTranslater.dataTypeToJava(f.type)» «f.name»);
	
	'''
	
	/* ---------------------------------------------------------------------------- *
	 * Implementation                                                                    *
	 * ---------------------------------------------------------------------------- */
	
	def compileBean(Form e) '''
		«IF false/* intent enforce */»«ENDIF»
		package «desc.domain».ejb.beans;
		
		import java.util.List;
		
		import javax.annotation.Generated;
		
		import javax.ejb.LocalBean;
		import javax.ejb.Stateless;
		import javax.persistence.EntityManager;
		import javax.persistence.PersistenceContext;
		import javax.persistence.Query;

		import «desc.domain».ejb.interfaces.«e.name»Service;
		import «desc.domain».jpa.«e.name»;
		
		/*
			This file has been automatically generated on «Calendar.getInstance().getTime()»,
			you may not edit this file but rather extend it
		*/
		
		@Stateless
		@Generated(value = { "http://www.stillhart.biz/xtext/Generator" })
		public class «e.name.toFirstUpper»ServiceBean implements «e.name»Service {		
		
			@PersistenceContext(unitName = "«desc.name»")
			protected EntityManager em;
		
			/**
			 * Creates a new «e.name.toFirstUpper»
			 * @param customer the customer
			 */
			@Override
			public void create(«e.name.toFirstUpper» «e.name.toLowerCase») {
				em.persist(«e.name.toLowerCase»);
			}
		
			/**
			 * Loads a «e.name.toFirstUpper» by it's Id
			 * @param id the id to search for
			 * @return the «e.name.toFirstUpper»
			 */
			@Override
			public «e.name.toFirstUpper» read(long id) {
				return em.find(«e.name.toFirstUpper».class, id);
			}

			/**
			 * Loads all «e.name.toFirstUpper»s
			 * @return all the «e.name.toFirstUpper»s
			 */
			@Override
			public List<«e.name.toFirstUpper»> readAll() {
				Query query = em.createQuery("SELECT e FROM «e.name.toFirstUpper» e");
				return (List<«e.name.toFirstUpper»>) query.getResultList();
			}
		
			/**
			 * Updates a «e.name.toFirstUpper»
			 * @param «e.name.toFirstUpper» the «e.name.toFirstUpper» with updated data
			 */
			@Override
			public void update(«e.name.toFirstUpper» «e.name.toLowerCase») {
				em.merge(«e.name.toLowerCase»);
			}
		
			/**
			 * Deletes a «e.name.toFirstUpper» 
			 * @param id the Id to remove
			 */
			@Override
			public void delete(long id) {
				«e.name.toFirstUpper» emp = read(id);
				if (emp != null) em.remove(emp);
			}
		
		}
	'''
	
}
