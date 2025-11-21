Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Import Data to Railway MySQL" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Link to Railway project
Write-Host "Linking to Railway project..." -ForegroundColor Yellow
railway link

# Get MySQL connection URL
Write-Host "Getting MySQL connection details..." -ForegroundColor Yellow
$mysqlUrl = railway variables get MYSQL_URL

if ([string]::IsNullOrEmpty($mysqlUrl)) {
    Write-Host "ERROR: Could not get MySQL URL" -ForegroundColor Red
    Write-Host "Make sure you're in the correct Railway project" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Parse MySQL URL: mysql://user:password@host:port/database
if ($mysqlUrl -match "mysql://([^:]+):([^@]+)@([^:]+):(\d+)/(.+)") {
    $user = $matches[1]
    $pass = $matches[2]
    $host = $matches[3]
    $port = $matches[4]
    $database = $matches[5]
    
    Write-Host ""
    Write-Host "Connection Details:" -ForegroundColor Green
    Write-Host "  Host: $host" -ForegroundColor White
    Write-Host "  Port: $port" -ForegroundColor White
    Write-Host "  Database: $database" -ForegroundColor White
    Write-Host "  User: $user" -ForegroundColor White
    Write-Host ""
    
    # MySQL executable path
    $mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe"
    
    if (-not (Test-Path $mysqlPath)) {
        Write-Host "ERROR: MySQL client not found at: $mysqlPath" -ForegroundColor Red
        Write-Host "Looking for MySQL in other locations..." -ForegroundColor Yellow
        
        # Try to find mysql.exe
        $mysqlPath = Get-ChildItem -Path "C:\Program Files\MySQL" -Recurse -Filter "mysql.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
        
        if ([string]::IsNullOrEmpty($mysqlPath)) {
            Write-Host "ERROR: Could not find mysql.exe" -ForegroundColor Red
            Read-Host "Press Enter to exit"
            exit 1
        }
        
        Write-Host "Found MySQL at: $mysqlPath" -ForegroundColor Green
    }
    
    Write-Host "Starting import..." -ForegroundColor Yellow
    Write-Host ""
    
    # Execute import
    $sqlFile = Join-Path $PSScriptRoot "RAILWAY_SEED_DATA.sql"
    
    if (-not (Test-Path $sqlFile)) {
        Write-Host "ERROR: RAILWAY_SEED_DATA.sql not found" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    # Run MySQL import
    & $mysqlPath -h $host -P $port -u $user "-p$pass" $database -e "source $sqlFile"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "Import Complete!" -ForegroundColor Green
        Write-Host "======================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Created:" -ForegroundColor Cyan
        Write-Host "  - 3 Event Organizer accounts" -ForegroundColor White
        Write-Host "  - 8 Sample events" -ForegroundColor White
        Write-Host ""
        Write-Host "Login Credentials:" -ForegroundColor Cyan
        Write-Host "  Email: sari.pro@eventhub.com" -ForegroundColor White
        Write-Host "  Password: Password123!" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "======================================" -ForegroundColor Red
        Write-Host "Import Failed!" -ForegroundColor Red
        Write-Host "======================================" -ForegroundColor Red
        Write-Host ""
        Write-Host "Error code: $LASTEXITCODE" -ForegroundColor Red
    }
} else {
    Write-Host "ERROR: Could not parse MySQL URL" -ForegroundColor Red
    Write-Host "URL format: $mysqlUrl" -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
