package biz.stillhart.xtext.validation

import biz.stillhart.xtext.generator.Form
import biz.stillhart.xtext.generator.GeneratorPackage
import org.eclipse.xtext.validation.Check
import biz.stillhart.xtext.generator.Field
import biz.stillhart.xtext.generator.Desc
import com.google.common.base.CharMatcher

/**
 * This class contains custom validation rules. 
 */
class GeneratorValidator extends AbstractGeneratorValidator {
	
	@Check
	def checkDomain(Desc desc) {
		if (CharMatcher.is('.').countIn(desc.domain) < 2) {
			warning('Domains are separated by dots ( e.g. biz.stillhart.generator )', 
					GeneratorPackage.Literals.DESC__DOMAIN)
		}
	}

	@Check
	def checkFormStartsWithCapital(Form form) {
		if (!Character.isUpperCase(form.name.charAt(0))) {
			warning('Forms usually start with a capital letter', 
					GeneratorPackage.Literals.FORM__NAME)
		}
	}
	
	@Check
	def checkFieldStartsWithLower(Field field) {
		if (!field.name.equals(field.name.toLowerCase())) {
			warning('Fields should be all lower case', 
					GeneratorPackage.Literals.FIELD__NAME)
		}
	}
	
}
