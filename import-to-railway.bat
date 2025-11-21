@echo off
echo ======================================
echo Import Data to Railway MySQL
echo ======================================
echo.

REM Get Railway MySQL connection details
echo Getting Railway MySQL connection info...
for /f "tokens=*" %%i in ('railway variables get MYSQL_URL') do set MYSQL_URL=%%i

if "%MYSQL_URL%"=="" (
    echo ERROR: Could not get MySQL URL from Railway
    echo Make sure you're in the correct Railway project
    pause
    exit /b 1
)

echo.
echo Parsing connection details...
echo.

REM Parse MySQL URL (format: mysql://user:password@host:port/database)
for /f "tokens=2 delims=/" %%a in ("%MYSQL_URL%") do set MYSQL_CREDS=%%a
for /f "tokens=1,2 delims=@" %%a in ("%MYSQL_CREDS%") do (
    set USER_PASS=%%a
    set HOST_PORT_DB=%%b
)
for /f "tokens=1,2 delims=:" %%a in ("%USER_PASS%") do (
    set MYSQL_USER=%%a
    set MYSQL_PASS=%%b
)
for /f "tokens=1,2 delims=/" %%a in ("%HOST_PORT_DB%") do set HOST_PORT=%%a
for /f "tokens=1,2 delims=:" %%a in ("%HOST_PORT%") do (
    set MYSQL_HOST=%%a
    set MYSQL_PORT=%%b
)
for /f "tokens=2 delims=/" %%a in ("%MYSQL_URL%") do (
    for /f "tokens=4 delims=/" %%b in ("%%a") do set MYSQL_DB=%%b
)

echo Connecting to: %MYSQL_HOST%:%MYSQL_PORT%
echo Database: %MYSQL_DB%
echo.
pause

REM Use full path to MySQL
"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% %MYSQL_DB% < RAILWAY_SEED_DATA.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ======================================
    echo Import Complete!
    echo ======================================
) else (
    echo.
    echo ======================================
    echo Import Failed!
    echo ======================================
)
pause
