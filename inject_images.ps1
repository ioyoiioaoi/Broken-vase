$htmlPath = ".\index.html"
$vasePath = ".\vase.png"
# Array of cube image paths
$cubePaths = @(".\cube1.jpg", ".\cube2.jpg", ".\cube3.jpg", ".\cube4.jpg", ".\cube5.jpg")

Write-Host "Reading HTML file..."
$html = Get-Content $htmlPath -Raw -Encoding utf8

# Inject Cube Textures
for ($i = 0; $i -lt $cubePaths.Count; $i++) {
    $path = $cubePaths[$i]
    $placeholder = "CUBE_TEX_$($i+1)_PLACEHOLDER"
    
    if (Test-Path $path) {
        Write-Host "Processing $path..."
        $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($path))
        $dataURI = "data:image/jpeg;base64,$b64"
        $html = $html.Replace("'$placeholder'", "'$dataURI'")
    }
    else {
        Write-Warning "File $path not found!"
    }
}

# Inject Vase Texture
if (Test-Path $vasePath) {
    Write-Host "Processing $vasePath..."
    $vaseB64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($vasePath))
    $vaseDataURI = "data:image/png;base64,$vaseB64"
    $html = $html.Replace("'VASE_PLACEHOLDER'", "'$vaseDataURI'")
}
else {
    Write-Warning "Vase file not found!"
}

Write-Host "Saving updated HTML..."
$html | Set-Content $htmlPath -Encoding utf8

Write-Host "Done! All images embedded."
