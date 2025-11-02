@echo off
setlocal enabledelayedexpansion

rem Load environment variables from .env if it exists
if exist .env (
    for /f "usebackq tokens=* delims=" %%a in (".env") do (
        set "line=%%a"
        for /f "tokens=* delims= " %%b in ("!line!") do set "line=%%b"
        if not "!line!"=="" (
            if not "!line:~0,1!"=="#" (
                if /i "!line:~0,6!"=="export" (
                    set "line=!line:~7!"
                    for /f "tokens=* delims= " %%b in ("!line!") do set "line=%%b"
                )
                for /f "tokens=1* delims==" %%b in ("!line!") do (
                    set "name=%%~b"
                    set "value=%%~c"
                    call :trim_spaces name
                    call :trim_spaces value
                    set "!name!=!value!"
                )
            )
        )
    )
)

goto :after_functions

:trim_spaces
set "var_name=%~1"
set "var_value=!%var_name%!"
if defined var_value (
    for /f "tokens=* delims= " %%z in ("!var_value!") do set "var_value=%%z"
    :trim_loop_end
    if defined var_value if "!var_value:~-1!"==" " (
        set "var_value=!var_value:~0,-1!"
        goto :trim_loop_end
    )
)
set "%var_name%=!var_value!"
exit /b

:after_functions

if "%MCP_ENDPOINT%"=="" (
    echo [ERROR] MCP_ENDPOINT environment variable is not set.
    echo         Please set MCP_ENDPOINT in your environment or inside the .env file.
    exit /b 1
)

where python >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Python is not installed or not found in PATH.
    exit /b 1
)

set "ARGS=%*"
if "%ARGS%"=="" (
    echo Starting mcp_pipe.py with mcp_config.json...
    python mcp_pipe.py
) else (
    echo Starting mcp_pipe.py with arguments: %ARGS%
    python mcp_pipe.py %*
)

endlocal
