package biz.stillhart.xtext.util;

import biz.stillhart.xtext.generator.DataType;
import biz.stillhart.xtext.generator.Field;

/**
 * Translates the ENUM in xText into Java Types and validation filters

 * @author Patrick Stillhart
 */
public class GModelTranslater {
	
	public static String dataTypeToJava(DataType datatype) {
		switch(datatype) { 
			case CHAR: return "char";
			case INT: return "int";
			case LONG: return "long";
			case BOOLEAN: return "boolean";
			case STRING: return "String";
		}
		return "";
	}

	public static String fieldToHTMLFilter(Field field) {
		String required = (field.getRequired() != null && field.getRequired().equals("!")) ? " required='true'" : "";
		switch(field.getType()) { 
			case CHAR: return "type='text' maxlength='1'" + required;
			case INT: return "type='number' min='"+ Integer.MIN_VALUE +"' max='"+ Integer.MAX_VALUE +"'" + required;
			case LONG: return "type='number' min='"+ Long.MIN_VALUE +"' max='"+ Long.MAX_VALUE +"'" + required;
			default: return "" + required;
		}
	}
	
	public static String fieldToAnnotationFilter(Field field) {
		String required = (field.getRequired() != null && field.getRequired().equals("!")) ? "\n@NotNull(message=\"This field may not be empty\")" : "";
		switch(field.getType()) { 
			case INT: return "@Min("+ Integer.MIN_VALUE +")\n@Max("+ Integer.MAX_VALUE +")" + required;
			case LONG: return "@Min("+ Long.MIN_VALUE +"l)\n@Max("+ Long.MAX_VALUE +"l)" + required;
			default: return required;
		}
	}

}
