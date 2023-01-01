@ECHO off

SET zipApp=%cd%"\7zip\7z.exe" a -bso0 -bsp1
SET htdocsDIR=C:\dev\wamp\www
SET destDir=D:\%date:~-4%-%date:~-7,2%-%date:~-10,2%

ECHO copy htdocs...
%zipApp% %destDir%\%date:~-4%-%date:~-7,2%-%date:~-10,2%-htdocs.zip %htdocsDIR% 2>nul
if %ERRORLEVEL% NEQ 0 (
	ECHO ERROR: zip htdocs
	goto :ende
)
ECHO DONE

ECHO ----------------------------

ECHO BACKUP DONE
PAUSE