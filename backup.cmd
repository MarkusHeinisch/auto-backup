@ECHO off

SET zip="d:\dev\7-Zip\7z.exe" a -bso0 -bsp1
SET destFolder=F:\backup\%date:~-4%%date:~-7,2%%date:~-10,2%
SET projects=D:\dev\_DATA
SET xampp=D:\dev\xampp
SET htdocs=D:\dev\xampp\htdocs
SET mysqlPath=D:\dev\xampp\mysql\bin
SET mysqlUser=root
SET mysqlPass=

IF NOT EXIST %projects% (
	ECHO Folder not exists!
	ECHO 	%projects%
	ECHO.
	PAUSE
	exit
)

IF NOT EXIST %htdocs% (
	ECHO Folder not exists!
	ECHO 	%htdocs%
	ECHO.
	PAUSE
	exit
)

IF EXIST %destFolder% (
	ECHO DestFolder already exists!
	ECHO 	%destFolder%
	ECHO.
	PAUSE
	exit
)

ECHO create destination folder...
IF NOT EXIST %destFolder% mkdir %destFolder%
IF NOT EXIST %destFolder% (
	ECHO ERROR: destination folder
	goto :ende
)
ECHO folder created DONE

ECHO ----------------------------

ECHO starting mysql-service...
cd %xampp%
START /MIN cmd /c mysql\bin\mysqld --defaults-file=mysql\bin\my.ini --standalone

ECHO backup databases...
cd %mysqlPath%
mysqldump --all-databases --result-file="%destFolder%\db_dump.sql" --user=%mysqlUser% --password=%mysqlPass% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO Attention! There was an error backing up the MySQL databases!
	ECHO Please check the backup script and the backup itself for errors.
	IF EXIST %destFolder%\db_dump.sql DEL %destFolder%\db_dump.sql
	goto :ende
)

ECHO stopping mysql-service...
cd %xampp%
START /MIN cmd /MIN /c mysql_stop.bat
ECHO mysql dump DONE

ECHO ----------------------------

ECHO copy projects...
%zip% %destFolder%\projects.zip %projects% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip projects
	goto :ende
)
ECHO zip projects DONE

ECHO ----------------------------

ECHO copy htdocs...
%zip% %destFolder%\htdocs.zip %htdocs% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip htdocs
	goto :ende
)
ECHO zip htdocs DONE

ECHO ----------------------------

ECHO BACKUP DONE
PAUSE