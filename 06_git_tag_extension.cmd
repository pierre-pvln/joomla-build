:: Name:     06_git_tag_extension.cmd
:: Purpose:  Add a tag to the extension in git!
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 09 29 - initial version


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

:: Setting for Error messages
SET ERROR_MESSAGE=errorfree

:: STATIC VARIABLES
:: ================
CD ..\04_settings\

IF EXIST 02_version.cmd (
   CALL 02_version.cmd
) ELSE (
   SET ERROR_MESSAGE=File with version info settings doesn't exist
   GOTO ERROR_EXIT
)

:: Check if required environment variables are set correctly
::
IF "%version%"=="" (
   SET ERROR_MESSAGE=version not defined in ..\04_settings\02_version.cmd
   GOTO ERROR_EXIT
   )
   
CD ..\00_dev_code

:: Sets the proper date and time stamp with 24Hr Time for log file naming convention
:: source http://stackoverflow.com/questions/1192476/format-date-and-time-in-a-windows-batch-script
::
SET HOUR=%time:~0,2%
SET dtStamp9=%date:~9,4%%date:~6,2%%date:~3,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
SET dtStamp24=%date:~9,4%%date:~6,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%
IF "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) ELSE (SET dtStamp=%dtStamp24%)

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Tagging extension with version: %version%
ECHO %me%: **************************************
ECHO.

:: Tag the extension with a version in Git
:: 
git tag -a %version% -m "version %version% tagged %dtStamp%"
git push -u origin %version%

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Done tagging extension with version: %version%
ECHO %me%: **************************************
ECHO.

GOTO CLEAN_EXIT

:ERROR_EXIT
cd "%cmd_dir%" 
ECHO *******************
ECHO Error: %ERROR_MESSAGE%
ECHO *******************

   
:CLEAN_EXIT   
:: Wait some time and exit the script
::
timeout /T 10
