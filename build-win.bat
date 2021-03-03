@echo off

rem A batch script I threw together in a day to make LOVE releases quickly on Windows.
rem Requires that curl and 7z be commands accessible from the CMD. They must be in PATH!
rem This code is simple enough that I don't care too much what's done with it,
rem it is public domain as far as I care, just say it was from me at the very least. Thanks.

rem Edit these as need be.
rem NAME is what certain output files will be called, like the exe and zip.
rem FILES should include all the necessary files and directories containing files. 7z will do the rest.
set "PROJECT_NAME=StrongVis" 
set "PROJECT_FILES=*.lua"

rem Edit these ONLY if you know what you're doing!
set "BUILD_DIR=%CD%\build"
set "CACHE_DIR=%CD%\build\cache"

set "START_DIR=%CD%"

if not exist %BUILD_DIR% echo Make build dir. && mkdir %BUILD_DIR%
if not exist %CACHE_DIR% echo Make cache dir. && mkdir %CACHE_DIR%

echo.
echo Packing game.
7z a %CACHE_DIR%\build.zip %PROJECT_FILES% > nul

echo.
echo Checking for LOVE binaries.
if not exist %CACHE_DIR%\love64.zip echo Downloading LOVE (x64). && curl https://github.com/love2d/love/releases/download/11.3/love-11.3-win64.zip -o %CACHE_DIR%\love64.zip -L -s
 
if not exist %CACHE_DIR%\love32.zip echo Downloading LOVE (x86). && curl https://github.com/love2d/love/releases/download/11.3/love-11.3-win32.zip -o %CACHE_DIR%\love32.zip -L -s

cd %CACHE_DIR%

echo.
echo Extracting LOVE binaries.
if not exist love64 7z e love64.zip -aoa -o* > nul
if not exist love32 7z e love32.zip -aoa -o* > nul

echo.
echo Building program binaries.
copy /b love64\love.exe+build.zip love64\%PROJECT_NAME%.exe > nul
copy /b love32\love.exe+build.zip love32\%PROJECT_NAME%.exe > nul

echo.
echo Packing into zips.
echo Packing 64-bit (x64) zip.
cd love64
7z a %BUILD_DIR%\%PROJECT_NAME%.x64.zip love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll %PROJECT_NAME%.exe > nul
cd ..\love32
echo Packing 32-bit (x86) zip.
7z a %BUILD_DIR%\%PROJECT_NAME%.x86.zip love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll %PROJECT_NAME%.exe > nul

cd %START_DIR%

echo.
echo Done, goodbye!
pause
