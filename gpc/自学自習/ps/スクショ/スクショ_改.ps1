Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screenshotCount = 0

function Take-Screenshot {
    param (
        [int]$screenIndex
    )

    $scriptDir = $PSScriptRoot
    $screen = [System.Windows.Forms.Screen]::AllScreens[$screenIndex]
    $bounds = $screen.Bounds
    $bitmap = New-Object Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)

    $timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss.fffff"
    $font = New-Object Drawing.Font("Arial", 16)
    $textBrush = [Drawing.Brushes]::White
    $backgroundBrush = [Drawing.Brushes]::Black
    $textSize = $graphics.MeasureString($timestamp, $font)
    $position = [Drawing.PointF]::new($bounds.Width - $textSize.Width - 10, $bounds.Height - $textSize.Height - 10)

    $graphics.FillRectangle($backgroundBrush, $position.X, $position.Y, $textSize.Width, $textSize.Height)
    $graphics.DrawString($timestamp, $font, $textBrush, $position)

    $fileTimestamp = Get-Date -Format "yyyyMMdd_HHmmss_fffff"
    $filePath = Join-Path -Path $scriptDir -ChildPath "Screenshot_$($screen.DeviceName.Replace('\\.\DISPLAY',''))_$fileTimestamp.png"

    try {
        $bitmap.Save($filePath, [Drawing.Imaging.ImageFormat]::Png)
        if (Test-Path -Path $filePath) {
            Write-Host "Screenshot taken at $timestamp on screen $screenIndex"
            $global:screenshotCount++
        } else {
            Write-Host "Failed to save screenshot at $timestamp on screen $screenIndex"
        }
    } catch {
        Write-Host "Failed to save screenshot at $timestamp on screen $screenIndex"
    }
}

$formSelectScreen = New-Object System.Windows.Forms.Form
$formSelectScreen.Text = "スクリーン選択"
$formSelectScreen.Size = New-Object System.Drawing.Size(300, 150)
$formSelectScreen.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

$formSelectScreen.Add_FormClosing({
    Write-Host "Total screenshots taken in this session: $global:screenshotCount"
})

$comboBox = New-Object System.Windows.Forms.ComboBox
$comboBox.Location = New-Object System.Drawing.Point(10, 20)
$comboBox.Size = New-Object System.Drawing.Size(260, 20)

[System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
    $comboBox.Items.Add($_.DeviceName)
}
$comboBox.SelectedIndex = 0
$formSelectScreen.Controls.Add($comboBox)

$confirmButton = New-Object System.Windows.Forms.Button
$confirmButton.Text = "確定"
$confirmButton.Location = New-Object System.Drawing.Point(10, 60)
$confirmButton.Size = New-Object System.Drawing.Size(100, 30)
$confirmButton.Add_Click({
    $selectedScreenIndex = $comboBox.SelectedIndex
    $formSelectScreen.Hide()

    $formShoot = New-Object System.Windows.Forms.Form
    $formShoot.Text = "スクリーンショット撮影"
    $formShoot.Size = New-Object System.Drawing.Size(200, 100)
    $formShoot.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    $shootButton = New-Object System.Windows.Forms.Button
    $shootButton.Text = "撮影"
    $shootButton.Dock = [System.Windows.Forms.DockStyle]::Fill

    $fontSize = $formShoot.ClientSize.Height * 0.4
    $shootButton.Font = New-Object System.Drawing.Font("Arial", $fontSize)

    $shootButton.Add_Click({
        Take-Screenshot -screenIndex $selectedScreenIndex
    })
    $formShoot.Controls.Add($shootButton)

    [void]$formShoot.ShowDialog()
    $formSelectScreen.Show()
})
$formSelectScreen.Controls.Add($confirmButton)

$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "終了"
$exitButton.Location = New-Object System.Drawing.Point(170, 60)
$exitButton.Size = New-Object System.Drawing.Size(100, 30)
$exitButton.Add_Click({
    $formSelectScreen.Close()
})
$formSelectScreen.Controls.Add($exitButton)

[void]$formSelectScreen.ShowDialog()
