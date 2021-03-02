@echo off

echo Checking for build dir.
if not exist build echo Make build dir. && mkdir build

echo.
echo Packing game.
7z a build\build.zip main.lua conf.lua > nul

echo.
echo Checking for LOVE binaries.
if not exist build\love64.zip echo Downloading LOVE (x64). && curl https://github.com/love2d/love/releases/download/11.3/love-11.3-win64.zip -o build\love64.zip -L -s
if not exist build\love32.zip echo Downloading LOVE (x86). && curl https://github.com/love2d/love/releases/download/11.3/love-11.3-win32.zip -o build\love32.zip -L -s

cd build

echo.
echo Extracting LOVE binaries.
if not exist love64 7z e love64.zip -aoa -o* > nul
if not exist love32 7z e love32.zip -aoa -o* > nul

echo.
echo Building program binaries.
copy /b love64\love.exe+build.zip love64\StrongVis.exe > nul
copy /b love32\love.exe+build.zip love32\StrongVis.exe > nul

echo.
echo Packing into zips.
echo Packing 64-bit (x64) zip.
cd love64
7z a ..\zStrongVis.x64.zip love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll StrongVis.exe > nul
cd ..\love32
echo Packing 32-bit (x86) zip.
7z a ..\zStrongVis.x86.zip love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll OpenAL32.dll SDL2.dll StrongVis.exe > nul
cd ..

cd ..

echo.
echo Done, goodbye!
pause
