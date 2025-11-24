$htmlPath = ".\index.html"
$assetsPath = ".\assets"
$html = Get-Content $htmlPath -Raw -Encoding utf8

$newBlock = "// --- Load Textures ---`nconst textureLoader = new THREE.TextureLoader();`nconst textureData = [`n"

0..4 | ForEach-Object {
    $p = "$assetsPath\art_$_.jpg"
    $b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($p))
    $newBlock += "  'data:image/jpeg;base64,$b64'," + "`n"
}
$newBlock += "];`nconst loadedTextures = textureData.map(data => textureLoader.load(data));"

$pattern = "(?s)// --- Load Textures ---.*?const loadedTextures = texturePaths\.map\(path => textureLoader\.load\(path\)\);"
$html = $html -replace $pattern, $newBlock

$html | Set-Content $htmlPath -Encoding utf8
Write-Host "Images embedded successfully."
