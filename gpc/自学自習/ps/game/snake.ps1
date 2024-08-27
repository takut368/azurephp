# スネークゲームの設定
$width = 20
$height = 10
$snake = @([PSCustomObject]@{ X = [math]::Floor($width / 2); Y = [math]::Floor($height / 2) })
$food = [PSCustomObject]@{ X = Get-Random -Minimum 0 -Maximum $width; Y = Get-Random -Minimum 0 -Maximum $height }
$direction = "Right"
$score = 0
$gameOver = $false

# ゲーム画面の描画
function Draw-Game {
    Clear-Host
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            if ($snake -contains [PSCustomObject]@{ X = $x; Y = $y }) {
                Write-Host -NoNewline "O"
            } elseif ($food.X -eq $x -and $food.Y -eq $y) {
                Write-Host -NoNewline "*"
            } else {
                Write-Host -NoNewline " "
            }
        }
        Write-Host ""
    }
    Write-Host "Score: $score"
}

# 食べ物の再配置
function Place-Food {
    $global:food = [PSCustomObject]@{ X = Get-Random -Minimum 0 -Maximum $width; Y = Get-Random -Minimum 0 -Maximum $height }
}

# ゲームのメインループ
function Play-Game {
    while (-not $gameOver) {
        Start-Sleep -Milliseconds 200

        # 方向の更新
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true).Key
            switch ($key) {
                "UpArrow" { if ($direction -ne "Down") { $direction = "Up" } }
                "DownArrow" { if ($direction -ne "Up") { $direction = "Down" } }
                "LeftArrow" { if ($direction -ne "Right") { $direction = "Left" } }
                "RightArrow" { if ($direction -ne "Left") { $direction = "Right" } }
            }
        }

        # スネークの移動
        $head = $snake[-1].PSObject.Copy()
        switch ($direction) {
            "Up" { $head.Y-- }
            "Down" { $head.Y++ }
            "Left" { $head.X-- }
            "Right" { $head.X++ }
        }

        # 衝突判定
        if ($head.X -lt 0 -or $head.X -ge $width -or $head.Y -lt 0 -or $head.Y -ge $height -or $snake -contains $head) {
            $global:gameOver = $true
            Write-Host "Game Over! Score: $score"
            break
        }

        # 食べ物を食べたかどうかの判定
        if ($head.X -eq $food.X -and $head.Y -eq $food.Y) {
            $score++
            Place-Food
        } else {
            $snake.RemoveAt(0)
        }

        # スネークの更新
        $snake += $head

        Draw-Game
    }
}

Place-Food
Draw-Game
Play-Game
