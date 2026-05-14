# Run demo helper
# Starts mock API and a simple static server, then opens the demo page in the default browser.

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$hgDir = Join-Path $scriptDir ''

Write-Host "Starting mock server (python .\hg\mock_server.py) ..."
$mock = Start-Process -FilePath python -ArgumentList ".\hg\mock_server.py" -WorkingDirectory $scriptDir -WindowStyle Hidden -PassThru
Start-Sleep -Milliseconds 800

Write-Host "Starting static server (python -m http.server 8001 in ./hg) ..."
$static = Start-Process -FilePath python -ArgumentList "-m","http.server","8001" -WorkingDirectory (Join-Path $scriptDir 'hg') -WindowStyle Hidden -PassThru
Start-Sleep -Milliseconds 800

$url = "http://localhost:8001/pls.html"
Write-Host "Opening $url"
Start-Process $url

Write-Host "Mock PID: $($mock.Id)  Static PID: $($static.Id)"
Write-Host "To stop servers: Stop-Process -Id <pid> or use Task Manager"
