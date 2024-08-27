# ブロック崩しゲームの設定
$width = 20
$height = 10
$ballX = $width / 2
$ballY = $height / 2
$ballDX = 1
$ballDY = -1
$paddleX = $width / 2 - 2
$paddleWidth = 5
$blocks = @{}
for ($x = 0; $x -lt $width; $x++) {
    for ($y = 0; $y -lt 3; $y++) {
        $blocks["$x,$y"] = $true
    }
}

# ゲーム画面の描画
function Draw-Game {
    cls
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            if ($x -eq $ballX -and $y -eq $ballY) {
                Write-Host -NoNewline "O"
            } elseif ($y -eq $height - 1 -and $x -ge $paddleX -and $x -lt $paddleX + $paddleWidth) {
                Write-Host -NoNewline "_"
            } elseif ($blocks["$x,$y"]) {
                Write-Host -NoNewline "#"
            } else {
                Write-Host -NoNewline " "
            }
        }
        Write-Host ""
    }
}

# ゲームのメインループ
function Play-Game {
    while ($true) {
        Start-Sleep -Milliseconds 100
        $ballX += $ballDX
        $ballY += $ballDY

        # 壁の衝突判定
        if ($ballX -lt 0 -or $ballX -ge $width) { $ballDX = -$ballDX }
        if ($ballY -lt 0) { $ballDY = -$ballDY }

        # パドルの衝突判定
        if ($ballY -ge $height - 1 -and $ballX -ge $paddleX -and $ballX -lt $paddleX + $paddleWidth) { $ballDY = -$ballDY }

        # ブロックの衝突判定
        if ($blocks["$ballX,$ballY"]) {
            $blocks["$ballX,$ballY"] = $false
            $ballDY = -$ballDY
        }

        # ゲームオーバー判定
        if ($ballY -ge $height) {
            Write-Host "Game Over!"
            break
        }

        Draw-Game

        # パドルの操作
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true).Key
            if ($key -eq "LeftArrow") { $paddleX = [Math]::Max(0, $paddleX - 1) }
            if ($key -eq "RightArrow") { $paddleX = [Math]::Min($width - $paddleWidth, $paddleX + 1) }
        }
    }
}

Draw-Game
Play-Game
