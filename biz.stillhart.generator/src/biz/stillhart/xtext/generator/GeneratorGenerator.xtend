package biz.stillhart.xtext.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import javax.inject.Inject
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.Path
import java.io.File
import biz.stillhart.xtext.util.FileUtil

/**
 * Combines results of all the Generators
 * 
 * @author Patrick Stillhart
 */
class GeneratorGenerator extends AbstractGenerator {

	@Inject extension EJBGenerator
	@Inject extension JPAGenerator
	@Inject extension WebGenerator
	@Inject extension XHTMLGenerator
	@Inject extension FileUtil
	
	@Inject private JavaIoFileSystemAccess fileAccess;

	override doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		
		val desc = resource.allContents.filter(Desc).head

		// setting and getting output directory
		fileAccess.setOutputPath("src-gen/")
		val outputPath = moveUp(
			new File(ResourcesPlugin.workspace.root.getFile(
				new Path(
					resource.URI.toPlatformString(true)
				)
			)
			.rawLocation.toOSString
			),2
		).toString + "/src-gen/";
		
		// set default database
		if(desc.database == null || desc.database.isEmpty()) desc.database = "java:comp/DefaultDataSource"
		
		// copy resource folder
		copyAndReplace("skeleton", outputPath, desc)
		
		// generate all the faces
		generateEJB(resource, fsa)
		generateJPA(resource, fsa)
		generateWeb(resource, fsa)
		generateXHTML(resource, fsa)
		
	}
	
}