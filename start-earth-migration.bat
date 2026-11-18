@echo off
setlocal EnableExtensions
chcp 65001 >nul

title The Earth Migration - Local Launcher

set "REPO_URL=https://github.com/huyue66666/earth-migration.git"
set "APP_DIR=%~dp0earth-migration"
set "PORT=%~1"
if "%PORT%"=="" set "PORT=8080"

echo.
echo ================================================
echo   The Earth Migration 本地启动器
echo ================================================
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [错误] 没有找到 Git。
    echo 请先安装 Git：https://git-scm.com/download/win
    pause
    exit /b 1
)

if not exist "%APP_DIR%\serve.py" (
    echo [1/3] 正在从 GitHub 下载项目...
    if exist "%APP_DIR%" rmdir /s /q "%APP_DIR%"
    git clone "%REPO_URL%" "%APP_DIR%"
    if errorlevel 1 (
        echo [错误] GitHub 项目下载失败。
        pause
        exit /b 1
    )
) else (
    echo [1/3] 正在检查项目更新...
    git -C "%APP_DIR%" pull --ff-only
    if errorlevel 1 (
        echo [提示] 自动更新失败，将继续使用当前本地版本。
    )
)

if exist "%APP_DIR%\serve.py" goto find_python

echo [错误] 项目文件不完整，找不到 serve.py。
pause
exit /b 1

:find_python
where py >nul 2>&1
if not errorlevel 1 goto use_py
where python >nul 2>&1
if not errorlevel 1 goto use_python

echo [错误] 没有找到 Python 3。
echo 请先安装 Python：https://www.python.org/downloads/windows/
pause
exit /b 1

:use_py
set "PYTHON_CMD=py -3"
goto start_server

:use_python
set "PYTHON_CMD=python"

:start_server
cd /d "%APP_DIR%"
echo.
echo [2/3] 正在启动本地服务器，端口：%PORT%
echo.
echo [3/3] 浏览器地址：
echo        http://127.0.0.1:%PORT%/beyond.html
echo        http://127.0.0.1:%PORT%/index.html
echo.
echo 关闭窗口即可停止服务器。
echo.
start "" "http://127.0.0.1:%PORT%/beyond.html"
%PYTHON_CMD% serve.py %PORT%

pause
