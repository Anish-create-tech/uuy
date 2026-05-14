# embed-images.ps1
# Usage: run from the hg/ folder: .\embed-images.ps1
# This script will:
#  - look for hg/images/river.jpg, taj-day.jpg, taj-sunset.jpg
#  - base64-encode each image and replace occurrences of those paths in HTT.html with data URIs
#  - create a backup HTT.html.bak before modifying

nparam()

n$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

n$map = @{
    'river.jpg' = 'images/river.jpg'
    'taj-day.jpg' = 'images/taj-day.jpg'
    'taj-sunset.jpg' = 'images/taj-sunset.jpg'
}

n$HtmlFile = Join-Path $root 'HTT.html'
if (-not (Test-Path $HtmlFile)) {
    Write-Error "File not found: $HtmlFile`nRun this script from the hg folder where HTT.html is located."
    exit 1
}

n$bak = "$HtmlFile.bak"
Copy-Item -Path $HtmlFile -Destination $bak -Force

n$html = Get-Content -Path $HtmlFile -Raw -Encoding UTF8

nforeach ($k in $map.Keys) {
    $imgRel = $map[$k]
    $imgPath = Join-Path $root $imgRel
    if (-not (Test-Path $imgPath)) {
        Write-Host "SKIP: image not found -> $imgRel" -ForegroundColor Yellow
        continue
    }
    try {
        $bytes = [System.IO.File]::ReadAllBytes($imgPath)
        $b64 = [System.Convert]::ToBase64String($bytes)
    } catch {
        Write-Host "ERROR reading $imgPath: $_" -ForegroundColor Red
        continue
    }
    switch ([IO.Path]::GetExtension($imgPath).ToLower()) {
        '.jpg' { $mime = 'image/jpeg' }
        '.jpeg' { $mime = 'image/jpeg' }
        '.png' { $mime = 'image/png' }
        default { $mime = 'application/octet-stream' }
    }
    $dataUri = "data:$mime;base64,$b64"
    $html = $html.Replace($imgRel, $dataUri)
    Write-Host "Embedded: $imgRel" -ForegroundColor Green
}

nSet-Content -Path $HtmlFile -Value $html -Encoding UTF8
Write-Host "Done. Updated HTT.html (backup at HTT.html.bak)" -ForegroundColor Cyan
Write-Host "Tip: review HTT.html and then commit the file if you're happy." -ForegroundColor Cyan
