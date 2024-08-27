Function Generate-Password {
  param (
      [int]$length = 15
  )

  # パスワード用文字定義
  $characters = [char[]]"abcdefghijklmnopqrstuvwxyz0123456789!"
  # ランダムパスワード生成
  $password = -join ($characters | Get-Random -Count $length)
  return $password
}

# 一意のパスワード格納用セット初期化
$passwords = @()
$blacklistedWords = @('takuto', 'kuramoto', 'ey', 'ps', 'hitachi', 'solutions')

while ($passwords.Count -lt 20) {
  $newPassword = Generate-Password 15

  # ユーザー名やメールの禁止語句含有チェック
  $isValid = $true
  foreach ($word in $blacklistedWords) {
      if ($newPassword.ToLower().Contains($word)) {
          $isValid = $false
          break
      }
  }

  if ($isValid -and -not $passwords.Contains($newPassword)) {
      $passwords += $newPassword
  }
}

# パスワード出力
$passwords
