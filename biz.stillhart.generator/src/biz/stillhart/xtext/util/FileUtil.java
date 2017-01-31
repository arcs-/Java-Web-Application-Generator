package biz.stillhart.xtext.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.URISyntaxException;
import java.net.URL;

import com.google.common.base.Charsets;
import com.google.common.io.Files;

import biz.stillhart.xtext.generator.Desc;

/**
 * Is able to read files from the project directory
 * 
 * @author Patrick Stillhart
 */
public class FileUtil {

	private final static String PROJECT_NAME = "biz.stillhart.generator";
	private final static String FOLDER_NAME = "resources";

	private Desc desc;

	/**
	 * Copies a folder to dest
	 * 
	 * @param dest
	 *            the folder where to copy to
	 */
	public void copyAndReplace(String orig, String dest, Desc desc) {
		this.desc = desc;

		URL url = FileUtil.class.getProtectionDomain().getCodeSource().getLocation();

		StringBuilder sb = new StringBuilder();
		try {
			sb
				.append(new File(url.toURI()).getParentFile().toString())
				.append(File.separator)
				.append(PROJECT_NAME)
				.append(File.separator)
				.append(FOLDER_NAME);

			if (!orig.isEmpty())
				sb
					.append(File.separator)
					.append(orig);

			copyDirectory(new File(sb.toString()), new File(dest));

		} catch (URISyntaxException | IOException e) {
			System.err.println("Failed");
			e.printStackTrace();
		}

	}

	/**
	 * Copies a folder form source to target
	 * 
	 * from http://stackoverflow.com/a/5368745/3137109
	 * 
	 * @param source the source folder
	 * @param target the target folder
	 * @throws IOException that was no folder with access rights
	 */
	private void copyDirectory(File source, File target) throws IOException {
		if(target.getAbsolutePath().contains("!!")) 
			target = new File(replaceTemplate(target.getAbsolutePath()));
		if (!target.exists())
			target.mkdir();

		for (String f : source.list()) {
			if (new File(source, f).isDirectory())
				copyDirectory(new File(source,f), new File(target, f));
			else
				copyFile(new File(source, f), new File(target, f));
		}
	}

	/**
	 * Copies a file and replaces all key words (e.g. !!word!! )
	 * 
	 * @param source
	 *            the source file
	 * @param target
	 *            the target file
	 * @throws IOException
	 *             well, something went wrong
	 */
	private void copyFile(File source, File target) throws IOException {
		try {
			FileReader fr = new FileReader(source);
			String s, totalStr = "";

			try (BufferedReader br = new BufferedReader(fr)) {
				while ((s = br.readLine()) != null) {
					if (s.contains("!!"))
						s = replaceTemplate(s);
					totalStr += s + System.lineSeparator();
				}
				FileWriter fw = new FileWriter(target);
				fw.write(totalStr);
				fw.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Loads the string reference from the Desc Class associated with the toReplace 
	 * 
	 * @param toReplace the key to look for
	 * @return the corresponding string
	 */
	private String replaceTemplate(String toReplace) {
		try {
			// get start and end of to replacing string
			int start = toReplace.indexOf("!!");
			int end = toReplace.indexOf("!!", start + 2);

			// get the key of the to replacing string
			String key = toReplace.substring(start + 2, end);

			// call desc with the modified key (e.g. domain => getDomain)
			Object value = (String) desc.getClass()
					.getMethod("get" + Character.toUpperCase(key.charAt(0)) + key.substring(1)).invoke(desc);

			// replace the string
			return toReplace.substring(0, start) + value + toReplace.substring(end + 2);

		} catch (IllegalAccessException | IllegalArgumentException | InvocationTargetException | NoSuchMethodException
				| SecurityException e) {
			System.err.println("noooot good");
			e.printStackTrace();
			return toReplace;

		}
	}

	/**
	 * Moves a folder up
	 * 
	 * @param file
	 *            origin place
	 * @param steps
	 *            folders up
	 * @return the new position
	 */
	public File moveUp(File file, int steps) {
		for (int i = 0; i < steps; i++)
			file = file.getParentFile();
		return file;
	}

	/**
	 * Reads a file from the project directory
	 * 
	 * @param filename
	 *            the name (or path to extend) of the file
	 * @return the content of the file
	 */
	public CharSequence get(String filename) {
		return get(filename, "");
	}

	/**
	 * Reads a file from the project directory
	 * 
	 * @param filename
	 *            the name (or path to extend) of the file
	 * @param prepend
	 *            a String to prepend in front of the result
	 * @return the content of the file
	 */
	public CharSequence get(String filename, String prepend) {

		try {

			URL url = FileUtil.class.getProtectionDomain().getCodeSource().getLocation();

			StringBuilder sb = new StringBuilder();
			sb.append(new File(url.toURI()).getParentFile().toString()).append(File.separator).append(PROJECT_NAME)
					.append(File.separator).append(FOLDER_NAME).append(File.separator).append(filename);

			return prepend + Files.toString(new File(sb.toString()), Charsets.UTF_8);

		} catch (URISyntaxException | IOException e) {
			e.printStackTrace();
			return "<!-- File not found -->";
		}

	}

}
