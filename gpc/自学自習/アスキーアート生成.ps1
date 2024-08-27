# ImageMagickのインストールが必要です
# 例: https://imagemagick.org/script/download.php

# 画像ファイルのパスを指定
$imagePath = "path\to\your\image.jpg"
$outputFile = "AsciiArt.txt"

# ImageMagickのconvertコマンドを使用して、画像をモノクロに変換し、アスキーアート化
$imageMagickPath = "C:\Program Files\ImageMagick-7.0.10-Q16-HDRI\convert.exe"
$asciiCharacters = "@%#*+=-:. "

# 画像を縮小してモノクロ化
$width = 100
$height = 50
$asciiArtImagePath = [System.IO.Path]::ChangeExtension($imagePath, ".txt")

# 画像を縮小してモノクロ化
& $imageMagickPath $imagePath -resize ${width}x${height} -monochrome $asciiArtImagePath

# モノクロ化した画像を読み込み
$imageData = Get-Content $asciiArtImagePath

# ピクセルをアスキー文字に変換
function ConvertTo-AsciiArt {
    param (
        [string[]]$imageData,
        [string]$asciiCharacters
    )

    $output = ""
    foreach ($line in $imageData) {
        $newLine = ""
        foreach ($char in $line.ToCharArray()) {
            if ($char -eq " ") {
                $newLine += " "
            } else {
                $index = [math]::Floor((($char - 0x20) / (0x7F - 0x20)) * ($asciiCharacters.Length - 1))
                $newLine += $asciiCharacters[$index]
            }
        }
        $output += "$newLine`n"
    }
    return $output
}

# アスキーアートを生成
$asciiArt = ConvertTo-AsciiArt -imageData $imageData -asciiCharacters $asciiCharacters

# 出力ファイルに保存
$asciiArt | Set-Content -Path $outputFile

Write-Host "アスキーアートが生成されました: $outputFile"
