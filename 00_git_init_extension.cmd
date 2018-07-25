:: Name:     00_git_init_extension.cmd
:: Purpose:  Put folder 00_dev_code under git control and link it to git repository
:: Author:   pierre.veelen@pvln.nl
:: Revision: 2018 07 16 - initial version
::           2018 02 09 - folderstructure and updateserver changed 
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
CALL ..\04_settings\00_name.cmd

CD ..\00_dev_code
:: check if folder is under git control
::
git status
IF %ERRORLEVEL% NEQ 0 (
:: if not initialize folder 
   git init
   git config --global user.name Pierre Veelen
   git config --global user.email pierre@pvln.nl
   git config --global color.ui auto
   :: Set remote
   git remote add origin git@github.com:pierre-pvln/%extension%.git
)
git remote -v
IF %ERRORLEVEL% EQU 0 (
   git add . 
   git commit -m "auto update"
   git push origin master 
) 

CD "%cmd_dir%"

pause
