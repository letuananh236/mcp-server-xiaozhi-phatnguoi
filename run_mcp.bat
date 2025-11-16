@echo off
setlocal EnableDelayedExpansion

set "EXIT_CODE=0"

pushd "%~dp0" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Unable to change directory to script location.
    exit /b 1
)

rem --- Load environment variables from .env (if available) ---
if exist ".env" (
    for /f "usebackq tokens=* delims=" %%A in (".env") do (
        set "line=%%A"
        call :trim line
        if not "!line!"=="" if not "!line:~0,1!"=="#" (
            if /i "!line:~0,7!"=="export " set "line=!line:~7!"
            for /f "tokens=1* delims==" %%B in ("!line!") do (
                set "key=%%~B"
                set "value=%%~C"
                call :trim key
                call :trim value
                set "value=!value:"=!"
                set "!key!=!value!"
            )
        )
    )
)

goto :after_helpers

:trim
set "__var_name=%~1"
set "__var_value=!%__var_name%!"
if defined __var_value (
    for /f "tokens=* delims= " %%Z in ("!__var_value!") do set "__var_value=%%Z"
    :trim_loop
    if defined __var_value if "!__var_value:~-1!"==" " (
        set "__var_value=!__var_value:~0,-1!"
        goto :trim_loop
    )
)
set "%__var_name%=!__var_value!"
exit /b

:after_helpers

rem --- Ensure MCP_ENDPOINT is configured ---
if "%MCP_ENDPOINT%"=="" (
    echo [ERROR] MCP_ENDPOINT environment variable is not set.
    echo         Please set MCP_ENDPOINT in your environment or inside the .env file.
    set "EXIT_CODE=1"
    goto :cleanup
)

rem --- Locate Python executable ---
set "PYTHON_CMD="
for %%P in (python.exe python3.exe py.exe) do (
    where %%P >nul 2>nul
    if not errorlevel 1 if not defined PYTHON_CMD set "PYTHON_CMD=%%P"
)

if not defined PYTHON_CMD (
    echo [ERROR] Python is not installed or not found in PATH.
    set "EXIT_CODE=1"
    goto :cleanup
)

set "ARGS=%*"
if "%ARGS%"=="" (
    echo Starting mcp_pipe.py with mcp_config.json...
    %PYTHON_CMD% mcp_pipe.py
) else (
    echo Starting mcp_pipe.py with arguments: %ARGS%
    %PYTHON_CMD% mcp_pipe.py %*
)
set "EXIT_CODE=%ERRORLEVEL%"

goto :cleanup

:cleanup
popd >nul 2>&1
endlocal & exit /b %EXIT_CODE%
