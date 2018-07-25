:: Name:     05_ftp_extension_to_servers.cmd
:: Purpose:  FTP files to updateserver
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2017 03 26 - initial version
::           2018 02 09 - folderstructure changed
::           2018 07 21 - update and download servers added
::           2018 07 24 - build process unified and extension as environment variable
::

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
call ..\04_settings\00_name.cmd
call ..\04_settings\02_version.cmd
call ..\04_settings\04_folders.cmd

cd ..\..\..\_secrets
call ftp_strato_settings.cmd
cd "%cmd_dir%" 

::
:: UPDATE SERVER
:: =============
ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Start transferring the %extension% file(s) to the update server
ECHO %me%: **************************************
ECHO.
::
:: Create _ftp_files.txt
::
:: remove any existing _ftp_files.txt file
IF EXIST "_ftp_files.txt" (del "_ftp_files.txt")

echo %ftp_user_updateserver%>>_ftp_files.txt
echo %ftp_pw_updateserver%>>_ftp_files.txt
echo binary>>_ftp_files.txt
echo cd %ftp_update_folder%>>_ftp_files.txt
echo put %output_dir%\index.html>>_ftp_files.txt
echo put %output_dir%\%extensionprefix%%extension%.xml>>_ftp_files.txt
echo bye>>_ftp_files.txt

:: run the actual FTP commandfile
ftp -s:_ftp_files.txt %ftp_updateserver%

del _ftp_files.txt

::
:: DOWNLOAD SERVER
:: =============
ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Start transferring the %extension% file(s) to the download server
ECHO %me%: **************************************
ECHO.
::
:: Create _ftp_files.txt
::
:: remove any existing _ftp_files.txt file
IF EXIST "_ftp_files.txt" (del "_ftp_files.txt")

echo %ftp_user_downloadserver%>>_ftp_files.txt
echo %ftp_pw_downloadserver%>>_ftp_files.txt
echo binary>>_ftp_files.txt
echo cd %ftp_download_folder%>>_ftp_files.txt
echo put %output_dir%\index.html>>_ftp_files.txt
echo put %output_dir%\%extensionprefix%%extension%_%version%.zip>>_ftp_files.txt
echo bye>>_ftp_files.txt

:: run the actual FTP commandfile
ftp -s:_ftp_files.txt %ftp_downloadserver%

del _ftp_files.txt

ECHO.
ECHO %me%: **************************************
ECHO %me%: %DATE% %TIME%
ECHO %me%: Done transferring the %extension% file(s)
ECHO %me%: **************************************
ECHO.

timeout /T 10
