@ECHO off

SET zipApp=%cd%"\7zip\7z.exe" a -bso0 -bsp1
SET htdocsDir=C:\dev\wamp\www
SET dateFormat=%date:~-4%-%date:~-7,2%-%date:~-10,2%
SET destDir=D:\%dateFormat%

ECHO copy htdocs...
%zipApp% %destDir%\%dateFormat%-htdocs.zip %htdocsDir% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip htdocs
	goto :ende
)
ECHO DONE

ECHO ----------------------------

ECHO BACKUP DONE
PAUSE