param (
    [string]$targetPath = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI",
    [string]$outputFormat = "txt", # txt, json, csv
    [switch]$showFiles = $true,
    [switch]$showFolders = $true,
    [string]$sizeUnit = "MB", # KB, MB, GB
    [int]$minSize = 0, # �ŏ��T�C�Y�t�B���^�����O (KB)
    [string]$filterExtension = ""
)

# �T�C�Y��ϊ�����֐�
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

# �t�H���_�\�����o�͂���֐�
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

# �X�N���v�g�����s����Ă���f�B���N�g�����擾
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# �o�̓t�@�C���̃p�X��ݒ�
$outputFile = Join-Path -Path $scriptDir -ChildPath "DirectoryStructure.$outputFormat"

# �o�̓t�@�C�������݂���ꍇ�A�폜
if (Test-Path -Path $outputFile) {
    Remove-Item -Path $outputFile
}

# �f�B���N�g���\�����擾���A�o�̓t�@�C���ɏ�������
$directoryStructure = Get-DirectoryStructure -path $targetPath

switch ($outputFormat) {
    "json" { $directoryStructure | ConvertTo-Json | Out-File -FilePath $outputFile -Encoding utf8 }
    "csv" { $directoryStructure | Out-File -FilePath $outputFile -Encoding utf8 }
    default { $directoryStructure | Out-File -FilePath $outputFile -Encoding utf8 }
}

Write-Host "�t�H���_�\����"$outputFile"�ɏo�͂��܂����B"
