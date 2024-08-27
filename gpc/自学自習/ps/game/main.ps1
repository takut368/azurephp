# マインスイーパーの設定
$width = 10
$height = 10
$numMines = 10
$board = @()
$revealed = @()
$mines = @()

# ボードの初期化
for ($y = 0; $y -lt $height; $y++) {
    $row = @()
    $revealedRow = @()
    $minesRow = @()
    for ($x = 0; $x -lt $width; $x++) {
        $row += 0
        $revealedRow += $false
        $minesRow += $false
    }
    $board += ,$row
    $revealed += ,$revealedRow
    $mines += ,$minesRow
}

# 地雷の配置
for ($i = 0; $i -lt $numMines; $i++) {
    do {
        $x = Get-Random -Minimum 0 -Maximum $width
        $y = Get-Random -Minimum 0 -Maximum $height
    } while ($mines[$y][$x])
    $mines[$y][$x] = $true

    # 周囲のマスのカウントを増やす
    for ($dy = -1; $dy -le 1; $dy++) {
        for ($dx = -1; $dx -le 1; $dx++) {
            $nx = $x + $dx
            $ny = $y + $dy
            if ($nx -ge 0 -and $nx -lt $width -and $ny -ge 0 -and $ny -lt $height) {
                $board[$ny][$nx]++
            }
        }
    }
}

# ボードの描画
function Draw-Board {
    Clear-Host
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $width; $x++) {
            if (-not $revealed[$y][$x]) {
                Write-Host -NoNewline "[#]"
            } elseif ($mines[$y][$x]) {
                Write-Host -NoNewline "[*]"
            } else {
                Write-Host -NoNewline "[$($board[$y][$x])]"
            }
        }
        Write-Host ""
    }
}

# マスを開く
function Reveal-Cell($x, $y) {
    if ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height -or $revealed[$y][$x]) {
        return
    }

    $revealed[$y][$x] = $true

    if ($board[$y][$x] -eq 0) {
        for ($dy = -1; $dy -le 1; $dy++) {
            for ($dx = -1; $dx -le 1; $dx++) {
                if ($dx -ne 0 -or $dy -ne 0) {
                    Reveal-Cell ($x + $dx) ($y + $dy)
                }
            }
        }
    }
}

# ゲームのメインループ
function Play-Game {
    while ($true) {
        Draw-Board
        $input = Read-Host "マスを開くには 'x,y' の形式で座標を入力してください (例: 3,4)"
        $coords = $input -split ","
        if ($coords.Length -ne 2) {
            Write-Host "無効な入力です。"
            continue
        }
        $x = [int]$coords[0]
        $y = [int]$coords[1]

        if ($x -lt 0 -or $x -ge $width -or $y -lt 0 -or $y -ge $height) {
            Write-Host "無効な座標です。"
            continue
        }

        if ($mines[$y][$x]) {
            $revealed[$y][$x] = $true
            Draw-Board
            Write-Host "ゲームオーバー！地雷を踏みました。"
            break
        }

        Reveal-Cell $x $y

        # 勝利判定
        $unrevealedCells = 0
        for ($y = 0; $y -lt $height; $y++) {
            for ($x = 0; $x -lt $width; $x++) {
                if (-not $revealed[$y][$x] -and -not $mines[$y][$x]) {
                    $unrevealedCells++
                }
            }
        }
        if ($unrevealedCells -eq 0) {
            Draw-Board
            Write-Host "おめでとうございます！すべての地雷を避けました。"
            break
        }
    }
}

Play-Game
