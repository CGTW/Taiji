Clear-Host

Write-Host "  +==========================================+" -ForegroundColor Cyan
Write-Host "  |         ***  Taiji Platform  ***         |" -ForegroundColor Cyan
Write-Host "  |                                          |" -ForegroundColor Cyan
Write-Host "  |  Search API  : Python / Tavily  :4000    |" -ForegroundColor Cyan
Write-Host "  |  Frontend    : Vue 3 + Vite      :3000    |" -ForegroundColor Cyan
Write-Host "  +==========================================+" -ForegroundColor Cyan
Write-Host ""

# ── Cleanup ──
Write-Host "  [0/2] Cleaning up previous sessions ..." -ForegroundColor Yellow
foreach ($port in @(4000, 3000)) {
    $conn = netstat -ano | Select-String "LISTENING.*$port "
    if ($conn) {
        foreach ($line in $conn) {
            $pid = ($line -replace '.*\s(\d+)$', '$1').Trim()
            if ($pid) { Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue }
        }
    }
}
Start-Sleep -Seconds 1
Write-Host "  [OK] Done" -ForegroundColor Green
Write-Host ""

# Load .env
$envFile = Join-Path $PSScriptRoot "search-api\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+)=(.+)\s*$") {
            [Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim(), "Process")
        }
    }
}

function Wait-WithSpinner($url, $maxRetries, $label) {
    $spin = @('|', '/', '-', '\')
    $ok = $false
    for ($i = 0; $i -lt $maxRetries; $i++) {
        $s = $spin[$i % 4]
        Write-Host "  `r  $s $label ..." -NoNewline
        Start-Sleep -Seconds 1
        $r = curl.exe -s -o NUL -w "%{http_code}" $url 2>$null
        if ($r -eq "200") { $ok = $true; break }
    }
    if ($ok) {
        Write-Host "  `r  [OK] $label" -ForegroundColor Green
    } else {
        Write-Host "  `r  [FAIL] $label" -ForegroundColor Red
    }
    return $ok
}

# ── Step 1: Start Search API ──
Write-Host ""
Start-Process -FilePath python -ArgumentList "$PSScriptRoot\search-api\run_windows.py" -WindowStyle Hidden `
    -RedirectStandardOutput "$PSScriptRoot\search-api\server.log" `
    -RedirectStandardError "$PSScriptRoot\search-api\server.err"

$ok = Wait-WithSpinner "http://localhost:4000/health" 15 "Search API :4000"
if (-not $ok) {
    $err = "$PSScriptRoot\search-api\server.err"
    if (Test-Path $err) { Get-Content $err -Tail 5 | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray } }
    exit 1
}

# ── Step 2: Start Frontend ──
Start-Process -FilePath "powershell" -ArgumentList "-NoExit", "-Command", "cd `"$PSScriptRoot\frontend`"; npm run dev" -WindowStyle Normal

$ok = Wait-WithSpinner "http://localhost:3000" 20 "Frontend  :3000"
if (-not $ok) {
    Write-Host "  [WARN] Frontend may still be starting" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  +----------------------------------------+" -ForegroundColor Green
Write-Host "  |  Frontend    : http://localhost:3000    |" -ForegroundColor Green
Write-Host "  |  Search API  : http://localhost:4000    |" -ForegroundColor Green
Write-Host "  +----------------------------------------+" -ForegroundColor Green
Write-Host "  |  Backend     : start manually           |" -ForegroundColor Gray
Write-Host "  +----------------------------------------+" -ForegroundColor Gray
Write-Host ""
