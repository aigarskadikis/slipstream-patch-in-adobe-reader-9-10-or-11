@echo off
set path=%path%;%~dp0
set src=%~dp0setup
set tmp=%~dp0temp
mkdir "%src%"
mkdir "%tmp%"
"%~dp07z.exe" x "%~dp0AdbeRdr*.exe" -o"%tmp%"
msiexec /a "%tmp%\AcroRead.msi" TARGETDIR="%src%" /qb
for /f "delims=" %%a in ('^
dir /b "%~dp0AdbeRdr*.msp" ^|
sed "s/.*Upd//g" ^|
awk -F ":" "{print $1 | """sort"""}"') DO (
for /f "delims=" %%b in ('dir /b "%~dp0*%%a"') do (
msiexec /update "%~dp0%%b" /a "%src%\AcroRead.msi" /qb
)
)
copy /Y "%tmp%\setup.exe" "%src%"
copy /Y "%tmp%\setup.ini" "%src%"
rd "%tmp%" /Q /S
pause
