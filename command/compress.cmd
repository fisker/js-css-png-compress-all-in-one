@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     JS/CSS Compress Script
echo    fisker(lionkay@gmail.com)
echo       2012-3-21
echo =====================================
echo.



REM 判断文件类型
set FILE_TYPE=%~x1
if "%FILE_TYPE%" NEQ ".js" (
    if "%FILE_TYPE%" NEQ ".css" (
        echo.
        echo !! 请选择 CSS 或 JS 文件 !!
        echo.
        goto End
    )
)

REM 检查 Java 环境
if "%JAVA_HOME%" == "" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto NoJavaHome

REM 生成压缩后的文件名，规则为：
REM 1. 文件名有 .dev 时: filename.dev.js -> filename.js
REM 2. 其它情况：filename.js -> filename.min.js
set RESULT_FILE=%~n1.min%~x1
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na%~x1
    )
)

set SOURCE_MAP_FILE=%RESULT_FILE%.map

REM 调用 yuicompressor 压缩CSS文件
if "%FILE_TYPE%" == ".css" (
    "%JAVA_HOME%\bin\java.exe" -jar "%~dp0..\yuicompressor\yuicompressor-2.4.7.jar" --charset UTF-8 "%~nx1" -o "%RESULT_FILE%"
)
REM 调用 compiler 压缩文件
if "%FILE_TYPE%" == ".js" (
    "%JAVA_HOME%\bin\java.exe" -jar "%~dp0..\compiler\compiler.jar"  --charset UTF-8 --js "%~nx1" --js_output_file "%RESULT_FILE%" --source_map_format=V3 --create_source_map "%SOURCE_MAP_FILE%"
    echo //# sourceMappingURL=%SOURCE_MAP_FILE% >> "%RESULT_FILE%"
)


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

:NoJavaHome
echo.
echo **** 请先安装 JDK 并设置 JAVA_HOME 环境变量
echo.

:End
ENDLOCAL
pause
