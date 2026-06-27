Clear-Host

$banner = @"
  +==========================================+
  |         ***  Search API  ***             |
  |         Engine : Tavily                  |
  |         Port   : 4000                    |
  +==========================================+
"@
Write-Host $banner -ForegroundColor Cyan

# Load .env
$envFile = Join-Path $PSScriptRoot ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+)=(.+)\s*$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
    Write-Host "  [OK] .env loaded" -ForegroundColor Green
} else {
    Write-Host "  [WARN] .env not found, using existing env vars" -ForegroundColor Yellow
}

Write-Host "  ... Launching server ..." -ForegroundColor Gray
Start-Process -FilePath python -ArgumentList "$PSScriptRoot\run_windows.py" -WindowStyle Hidden
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "  +----------------------------------------+" -ForegroundColor Green
Write-Host "  |  READY  >>  http://localhost:4000       |" -ForegroundColor Green
Write-Host "  +----------------------------------------+" -ForegroundColor Green
Write-Host ""
