:: Name:     01_build_extension_zip.cmd
:: Purpose:  Create the module zip file which can be installed in Joomla!
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2016 03 26 - initial version
::           2016 07 17 - backup of older module files added
::           2016 07 23 - version for zip output file added	and update server added
::           2016 08 01 - versioning applyed through seperate set_version.cmd
::           2017 03 26 - module name as variable included
::           2018 02 09 - folderstructure and updateserver changed 
::           2018 07 24 - build process unified and extension as environment variable

@ECHO off
SETLOCAL ENABLEEXTENSIONS

:: BASIC SETTINGS
:: ==============
:: Setting the name of the script
SET me=%~n0
:: Setting the name of the directory with this script
SET parent=%~p0
:: Setting the drive of this commandfile
SET drive=%~d0
:: Setting the directory and drive of this commandfile
SET cmd_dir=%~dp0

:: STATIC VARIABLES
:: ================
CALL ..\04_settings\00_name.cmd
CALL ..\04_settings\02_version.cmd
CALL ..\04_settings\04_folders.cmd
CD "%cmd_dir%"

:: Sets the proper date and time stamp with 24Hr Time for log file naming convention
:: source http://stackoverflow.com/questions/1192476/format-date-and-time-in-a-windows-batch-script
::
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~9,4%%date:~6,2%%date:~3,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
SET dtStamp24=%date:~9,4%%date:~6,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
IF "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) ELSE (SET dtStamp=%dtStamp24%)

:: Als er al extension bestand bestaat copieer het dan naar de back-up directory en geef het dan een nieuwe naam.
:: Dat zorgt ervoor dat er altijd een correct module bestand gemaakt wordt.
:: Indien het zip bestand namelijk al bestaat worden alleen bestanden/mappen toegevoegd maar niet verwijderd als ze niet meer nodig zijn
::
IF EXIST "%output_dir%\%extensionprefix%%extension%_%version%.zip" (
	:: check if back_up directory exists
	IF NOT EXIST "%backup_dir%" (md "%backup_dir%")
	COPY "%output_dir%\%extensionprefix%%extension%_%version%.zip" "%backup_dir%\%extensionprefix%%extension%_%version%_%dtStamp%.zip"
	DEL  "%output_dir%\%extensionprefix%%extension%_%version%.zip"
)

:: Copy files for update server
:: /y = don't prompt when overwriting files from source that already exist in destination.
::
xcopy ..\00_dev_code\update_server\* "%output_dir%\" /y

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Start creating the %extensionprefix%%extension%_%version%.zip extension file
ECHO %me%: **************************************
ECHO.

:: Create the installable extension zip file
:: 
"C:\Program Files\7-Zip\7z.exe" a -tzip "%output_dir%\%extensionprefix%%extension%_%version%.zip" "..\00_dev_code\*" -xr@"..\04_settings\files_to_exclude_in_zip.txt"

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Done creating the %extensionprefix%%extension%_%version%.zip extension file
ECHO %me%: **************************************
ECHO.

:: Wait some time and exit the script
::
timeout /T 10
