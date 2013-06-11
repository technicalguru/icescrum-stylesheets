1. LICENSE INFORMATION
2. DEPENDENCIES
3. SUPPORT INFORMATION
4. USAGE

1. License Information
======================

 *  IceScrum Stylesheets is free software: you can redistribute it 
 *  and/or modify it under the terms of version 3 of the GNU 
 *  Lesser General Public  License as published by the Free Software 
 *  Foundation.
 *  
 *  IceScrum Stylesheets is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public 
 *  License along with IceScrum Stylesheets.  If not, see 
 *  <http://www.gnu.org/licenses/lgpl-3.0.html>.

	Summary:
		1. You are free to use all this code in any private or commercial project. 
		2. You must distribute license and author information along with your project.
		3. You are not required to publish your own source code.
		
		 
2. Dependencies
===============

	This project was developed and tested with Java 7 only. Following libraries
	are required when you use this code:
	
	icescrum-stylesheets.jar	- Main library

	commons-cli-1.2.jar	- required for PostProcess
	commons-codec-1.4.jar	- required for PostProcess
	
	junit.jar 	- required for testing with JUnit 4 (not delivered)
	
3. Support Information
======================

	Project Homepage: http://techblog.ralph-schuster.eu/icescrum-stylesheets/
	Report a Bug or Change: http://bugzilla.ralph-schuster.eu/bugzilla/
	 
4. Usage
========

    This project was created due to migrating problems of IceScrum from R3 to
    R5. It will take project exports from R3 IceScrum, translate it via the
    given XSL stylesheet translation and post-process it with Java.
    
    So here are the steps that you need to perform:
    
    1. Export your project from IceScrum R3
    2. Translate the XML produced by IceScrum using the R3toR5.xsl definition
    3. Post-process the translated XML with
    
       java icescrum.xsl.PostProcess -i <input-file> -o <output-file>
       
    4. Import the XML file that was post-processed into IceScrum R5.
    
    I migrated a major project with almost 1200 tasks and 30 users using
    this project. I only lost some historical statistics. But all releases,
    sprints, tasks, users were migrated successfully without any problem.