# Copy common images from your Downloads folder into the repo's images/ folder so GitHub Pages can serve them.
# Usage: run this in PowerShell on your machine (Windows).

$repo = Join-Path $env:USERPROFILE 'OneDrive\patanhi\hg'
$imagesDir = Join-Path $repo 'images'
if (-not (Test-Path $imagesDir)) { New-Item -ItemType Directory -Path $imagesDir | Out-Null }

$downloads = Join-Path $env:USERPROFILE 'Downloads'

# List of filenames to copy from Downloads -> hg/images (update if your filenames differ)
$map = @(
    @{ src = 'RxRLandingPage-1600x1600.jpg'; dst = 'rxr-1600.jpg' },
    @{ src = 'istockphoto-509112518-612x612 (1).jpg'; dst = 'istock-509112518.jpg' },
    @{ src = 'shutterstock_2001891602-1024x580 (1).jpg'; dst = 'shutterstock-2001891602.jpg' }
)

foreach ($m in $map) {
    $src = Join-Path $downloads $m.src
    $dst = Join-Path $imagesDir $m.dst
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "Copied: $($m.src) -> images/$($m.dst)"
    } else {
        Write-Warning "Missing in Downloads: $($m.src). Please place it in $downloads or update the script filenames."
    }
}

Write-Host "Done. Check the folder: $imagesDir"