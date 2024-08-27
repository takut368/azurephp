Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

try {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
    [System.Windows.Forms.Screen]::AllScreens | ForEach-Object {
        $screen = $_
        $bounds = $screen.Bounds
        $bitmap = New-Object Drawing.Bitmap $bounds.Width, $bounds.Height
        $graphics = [Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)

        # 描画
        $timestamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
        $font = New-Object Drawing.Font("Arial", 25)
        $textBrush = [Drawing.Brushes]::White
        $backgroundBrush = [Drawing.Brushes]::Black
        $textSize = $graphics.MeasureString($timestamp, $font)
        $position = [Drawing.PointF]::new($bounds.Width - $textSize.Width - 10, $bounds.Height - $textSize.Height - 10)
        $graphics.FillRectangle($backgroundBrush, $position.X, $position.Y, $textSize.Width, $textSize.Height)
        $graphics.DrawString($timestamp, $font, $textBrush, $position)

        # 保存
        $fileTimestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $filePath = Join-Path -Path $scriptDir -ChildPath "ss_$($screen.DeviceName.Replace('\\.\DISPLAY',''))_$fileTimestamp.png"
        $bitmap.Save($filePath, [Drawing.Imaging.ImageFormat]::Png)

        Write-Host "Screenshot of $($screen.DeviceName) saved to $filePath"
    }
} catch {
    Write-Host "$_"
}
