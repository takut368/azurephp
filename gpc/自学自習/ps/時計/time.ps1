# デジタル時計を表示
while ($true) {
  Clear-Host
  Write-Host (Get-Date).ToString('HH:mm:ss')
  Start-Sleep -Seconds 1
}
