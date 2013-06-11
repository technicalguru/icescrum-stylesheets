/**
 * 
 */
package icescrum.xsl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.Parser;
import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Post-processes generated XML files.
 * @author ralph
 *
 */
public class PostProcess implements Runnable {

	private static Logger log = LoggerFactory.getLogger(PostProcess.class);
	
	private InputStream in;
	private OutputStream out;
	private Map<String,Map<String,String>> md5Map = new HashMap<String, Map<String,String>>();

	/**
	 * Constructor.
	 * @param in input stream (must be closed by caller after run)
	 * @param out output stream (must be closed by caller after run)
	 */
	public PostProcess(InputStream in, OutputStream out) {
		this.in= in;
		this.out = out;
	}

	/**
	 * Run the post-processing.
	 */
	@Override
	public void run() {
		try {
			// The streams
			BufferedReader in = new BufferedReader(new InputStreamReader(this.in));
			PrintWriter out = new PrintWriter(this.out);
			
			// Process the stream
			String line = null;
			while ((line = in.readLine()) != null) {
				line = checkMD5("team", line);
				line = checkMD5("user", line);
				line = checkMD5(line);
				out.println(line);
			}
			out.flush();
		} catch (Throwable t) {
			throw new RuntimeException("Cannot post-process XML", t);
		}
	}

	/**
	 * Checks whether a MD5 hash has to be produced and replaces the
	 * line with this MD5 hash.
	 * @param tagName
	 * @param line
	 * @return
	 */
	protected String checkMD5(String tagName, String line) {
		String s = "<"+tagName+" uid=\"md5:";
		int tagLength = tagName.length();
		int pos = line.indexOf(s);
		while (pos >= 0) {
			int idEndPos = line.indexOf(':', pos+11+tagLength);
			String id = line.substring(pos+11+tagLength, idEndPos);
			int endPos = line.indexOf('"', idEndPos+1);
			String value = line.substring(idEndPos+1, endPos);
			String md5 = md5(value);
			//log.debug(tagName+" "+id+"="+value+" "+md5);
			registerMD5(tagName, id, md5);
			line = line.substring(0, pos+7+tagLength)+md5+line.substring(endPos);
			pos = line.indexOf(s, pos+7+tagLength+md5.length());
			//log.debug("   "+line);
		}
		return line;
	}
	
	/**
	 * Checks whether the line has references to existing hashes
	 * and replaces them.
	 * @param line
	 * @return
	 */
	protected String checkMD5(String line) {
		for (Map.Entry<String, Map<String, String>> entry : md5Map.entrySet()) {
			String key = entry.getKey();
			int keyLength = key.length();
			int pos = line.indexOf("uid=\""+entry.getKey()+":");
			while (pos >= 0) {
				int endIndex = line.indexOf('"', pos+keyLength+6);
				String id = line.substring(pos+keyLength+6, endIndex);
				String md5 = entry.getValue().get(id);
				if (md5 != null) {
					//log.debug("MD5("+key+":"+id+")="+md5);					
					line = line.substring(0, pos+5)+md5+line.substring(endIndex);
					pos = line.indexOf("uid=\""+entry.getKey()+":", pos+7+keyLength+md5.length());
					//log.debug("   "+line);
				} else {
					//log.debug("MD5("+key+":"+id+")=NULL");
					line = line.substring(0, line.lastIndexOf('<', pos))+line.substring(line.indexOf('>', pos)+1);
					pos = line.indexOf("uid=\""+entry.getKey()+":", endIndex);
					//log.debug("   "+line);
				}
			}
		}
		return line;
	}
	
	/**
	 * Registers a MD5 hash for an ID
	 * @param type type of ID
	 * @param id ID
	 * @param md5 MD5 hash
	 */
	protected void registerMD5(String type, String id, String md5) {
		Map<String,String> typeMap = md5Map.get(type);
		if (typeMap == null) {
			typeMap = new HashMap<String, String>();
			md5Map.put(type, typeMap);
		}
		typeMap.put(id, md5);
	}
	
	/**
	 * Returns the MD5 hash.
	 * @param s string to hash
	 * @return MD5 hash
	 * @throws Exception
	 */
	protected static String md5(String s) {
		return DigestUtils.md5Hex(s);
	}
	
	/**
	 * The main class.
	 * @param args
	 */
	public static void main(String[] args) {
		try {
			log.info("PostProcessing started");
			
			// Basic MD5 test
			String s = md5("adminadmin@icescrum.com");
			if (s.equals("8727684d5d11b608d4e6ebe971c03e8e")) log.debug("MD5 Test Check was successful");
			else {
				log.error("MD5 Test check failed: "+s);
				return;
			}
			
			// Parse the command line
			Parser parser = new GnuParser();
			CommandLine cl = parser.parse(getCommandLineOptions(), args);

			// Input stream
			InputStream in = null;
			File inFile = new File(cl.getOptionValue("i"));
			if (!inFile.exists() || !inFile.canRead()) {
				log.error("Cannot read \""+inFile.getAbsolutePath()+"\"");
				return;
			}
			in = new FileInputStream(inFile);
			
			// OutputStream
			OutputStream out = System.out;
			s = cl.getOptionValue("o");
			if (s != null) {
				File outFile = new File(s);
				if ((outFile.exists() && !outFile.canWrite()) || (!outFile.exists() && !outFile.getParentFile().canWrite())) {
					log.error("Cannot write \""+outFile.getAbsolutePath()+"\"");
					return;
				}
				out = new FileOutputStream(outFile);
			}
			
			
			PostProcess p = new PostProcess(in, out);
			p.run();
			
		} catch (ParseException e) {
			HelpFormatter f = new HelpFormatter();
			f.printHelp(PostProcess.class.getName(), getCommandLineOptions(), false);
			//log.error(e);
		} catch (Exception e) {
			log.error("Error occurred", e);
		} finally {
			log.info("PostProcessing finished");
		}
	}

	/**
	  * Creates the command line options.
	  * @return CL options object
	  */
	protected static Options getCommandLineOptions() {
		Options rc = new Options();
		Option option = null;

		option = new Option("i", "input", true, "XML file to process");
		option.setRequired(true);
		option.setArgs(1);
		rc.addOption(option);

		option = new Option("o", "output", true, "XML target file");
		option.setRequired(false);
		option.setArgs(1);
		rc.addOption(option);
		return rc;
	}


}
