# ログファイルのパスを設定
$logFilePath = ".\sample.log"

# ログファイルへの書き込み関数
function Write-Log {
    Param (
        [string]$Message
    )

    # 現在の日時を取得
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    # ログメッセージをフォーマット
    $logEntry = "$timestamp : $Message"
    # ログファイルに書き込む
    Add-Content -Path $logFilePath -Value $logEntry
}

try {
    # ゼロ除算エラーを意図的に発生させる
    $result = 1 / 0
}
catch {
    # エラーメッセージをログファイルに記録
    Write-Log "reigai: $_"
}
finally {
    # 最終的なメッセージをログに記録
    Write-Log "success"
}

# ログファイルを表示
Get-Content $logFilePath
