@ECHO off

SET zipApp=%cd%"\7zip\7z.exe" a -bso0 -bsp1
SET htdocsDir=C:\dev\wamp\www
SET projectsDir=C:\dev\_DATA
SET dateFormat=%date:~-4%-%date:~-7,2%-%date:~-10,2%
SET destDir=D:\%dateFormat%
SET mysqlPath=C:\dev\wamp\bin\mysql\mysql5.7.40
SET mysqlUser=root
SET mysqlPass=

IF EXIST %destDir% (
	ECHO destination directory already exists!
	ECHO 	%destDir%
	ECHO.
	PAUSE
	exit
)

ECHO create destination directory...
IF NOT EXIST %destDir% mkdir %destDir%
IF NOT EXIST %destDir% (
	ECHO ERROR: destination directory
	goto :end
)
ECHO DONE

ECHO ----------------------------

ECHO starting mysql-service...
cd %mysqlPath%
START /MIN cmd /c bin\mysqld --defaults-file=my.ini --standalone

timeout /t 5 /nobreak > NUL

ECHO backup databases...
cd %mysqlPath%/bin
mysqldump --all-databases --result-file="%destDir%\%dateFormat%-db_dump.sql" --user=%mysqlUser% --password=%mysqlPass% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO Attention! There was an error backing up the MySQL databases!
	ECHO Please check the backup script and the backup itself for errors.
	IF EXIST %destDir%\%dateFormat%-db_dump.sql DEL %destDir%\%dateFormat%-db_dump.sql
	goto :end
)

::ECHO stopping mysql-service...
::cd %xampp%
::START /MIN cmd /MIN /c mysql_stop.bat
ECHO DONE

ECHO ----------------------------

ECHO copy projects...
%zipApp% %destDir%\%dateFormat%-projects.zip %projectsDir% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip projects
	goto :ende
)
ECHO DONE

ECHO ----------------------------

ECHO copy htdocs...
%zipApp% %destDir%\%dateFormat%-htdocs.zip %htdocsDir% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip htdocs
	goto :end
)
ECHO DONE

:end
ECHO ----------------------------
ECHO End of batch program.
PAUSE