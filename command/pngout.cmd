@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     Image Compress Script
echo    fisker(lionkay@gmail.com)
echo       2012-3-21
echo =====================================
echo.

REM �ж��ļ�����
set FILE_TYPE=%~x1
for %%i in (.png .gif .jpg) do (if "%FILE_TYPE%"=="%%i" goto COMPRESS)

:COMPRESS
REM ����ѹ������ļ���������Ϊ��
REM 1. �ļ����� .dev ʱ: filename.dev.png -> filename.png
REM 2. ���������filename.png -> filename.min.png
set RESULT_FILE=%~n1.min%.png
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na.png
    )
)
"%~dp0\..\pngout\pngout.exe" /y "%~n1%~x1" "%RESULT_FILE%"

:END
ENDLOCAL
echo.
pause