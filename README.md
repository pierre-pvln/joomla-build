# Generic Build Process Scripts
Generic build scripts for Joomla! website extensions.

* Documentation and download extension: <br/>
http://www.pvln.nl/build-extensions <br/>

Below folder structure should be present on the workstation on which development is done:
```
extensionname\00_dev_code       folder with the code for the joomla extension, 
                                which gets installed on the Joomla! website
             \02_build_process  folder with scripts to build the extension zipfile
                                and deploy it to the Joomla! webserver
             \04_settings       folder with settings used by scripts in 02_build_process
             \06_output         folder with the ouput files from the 02_build_process scripts
             \07_documentation  folder with documentation on the extension, the ToDo list
             \08_sources        folder with relevant information links and inspiration
                                used to create the extension
```

The downloadable extension zip file is available at:
```
 download.pvln.nl/joomla/<extensiontype>/<extensionname>/
```

The downloadable extension update xml file is available at:
```
 update.pvln.nl/joomla/<extensiontype>/<extensionname>/
```
