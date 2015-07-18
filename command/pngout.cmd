@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     Image Compress Script
echo    fisker(lionkay@gmail.com)
echo       2012-3-21
echo =====================================
echo.

REM 判断文件类型
set FILE_TYPE=%~x1
for %%i in (.png .gif .jpg) do (if "%FILE_TYPE%"=="%%i" goto COMPRESS)

:COMPRESS
REM 生成压缩后的文件名，规则为：
REM 1. 文件名有 .dev 时: filename.dev.png -> filename.png
REM 2. 其它情况：filename.png -> filename.min.png
set RESULT_FILE=%~n1.min%.png
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na.png
    )
)
"%~dp0\..\pngout\pngout.exe" /y "%~n1%~x1" "%RESULT_FILE%"
REM "%~dp0\..\pngout\pngout.exe" /k1 /r /v /y "%~n1%~x1" "%RESULT_FILE%"

REM 显示压缩结果
if %ERRORLEVEL% == 0 (
    echo.
    echo 压缩文件 %~nx1 到 %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo 文件大小从 %~z1 bytes 压缩到 %%~za bytes
    )
    echo.
) else (
    echo.
    echo **** 文件 %~nx1 中有语法错误，请仔细检查
    echo.
	goto End
)
goto End

:END
ENDLOCAL
echo.
pause