param (
    [string]$targetPath = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI",
    [string]$outputFormat = "txt", # txt, json, csv
    [switch]$showFiles = $true,
    [switch]$showFolders = $true,
    [string]$sizeUnit = "MB", # KB, MB, GB
    [int]$minSize = 0, # 最小サイズフィルタリング (KB)
    [string]$filterExtension = ""
)

# サイズを変換する関数
function Convert-Size {
    param (
        [long]$size,
        [string]$unit
    )

    switch ($unit) {
        "KB" { return [math]::Round($size / 1KB, 2) }
        "MB" { return [math]::Round($size / 1MB, 2) }
        "GB" { return [math]::Round($size / 1GB, 2) }
        default { return $size }
    }
}

# フォルダ構成を出力する関数
function Get-DirectoryStructure {
    param (
        [string]$path,
        [string]$indent = ""
    )

    $items = Get-ChildItem -Path $path

    foreach ($item in $items) {
        if ($item.PSIsContainer) {
            if ($showFolders) {
                $folderSize = (Get-ChildItem -Path $item.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
                $folderOutput = "$indent+---$($item.Name) $(Convert-Size -size $folderSize -unit $sizeUnit) $sizeUnit"
                Write-Output $folderOutput
                Get-DirectoryStructure -path $item.FullName -indent ("$indent`|   ")
            }
        } else {
            if ($showFiles -and ($filterExtension -eq "" -or $item.Extension -eq $filterExtension)) {
                $fileSize = Convert-Size -size $item.Length -unit $sizeUnit
                if ($fileSize -ge $minSize) {
                    $fileOutput = "$indent`|---$($item.Name) $fileSize $sizeUnit"
                    Write-Output $fileOutput
                }
            }
        }
    }
}

# スクリプトが実行されているディレクトリを取得
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 出力ファイルのパスを設定
$outputFile = Join-Path -Path $scriptDir -ChildPath "DirectoryStructure.$outputFormat"

# 出力ファイルが存在する場合、削除
if (Test-Path -Path $outputFile) {
    Remove-Item -Path $outputFile
}

# ディレクトリ構成を取得し、出力ファイルに書き込み
$directoryStructure = Get-DirectoryStructure -path $targetPath

switch ($outputFormat) {
    "json" { $directoryStructure | ConvertTo-Json | Out-File -FilePath $outputFile -Encoding utf8 }
    "csv" { $directoryStructure | Out-File -FilePath $outputFile -Encoding utf8 }
    default { $directoryStructure | Out-File -FilePath $outputFile -Encoding utf8 }
}

Write-Host "フォルダ構成を"$outputFile"に出力しました。"
