# アセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# エラーメッセージボックスの表示
function Show-Error {
    [System.Windows.Forms.MessageBox]::Show("入力は空白にできません。", "エラー", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# 入力フォームの作成と表示
function Show-InputForm {
    $form = New-Object Windows.Forms.Form -Property @{
        Text = "入力フォーム"
        Size = New-Object Drawing.Size(800, 300)
        StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        MaximizeBox = $false
    }

    $label = New-Object Windows.Forms.Label -Property @{
        Text = "テキストを入力してください:"
        AutoSize = $true
        Font = New-Object Drawing.Font("メイリオ", 16)
        TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        Dock = [System.Windows.Forms.DockStyle]::Top
        Padding = New-Object Windows.Forms.Padding(0, 20, 0, 20)
    }
    $form.Controls.Add($label)

    $textBox = New-Object Windows.Forms.TextBox -Property @{
        Font = New-Object Drawing.Font("メイリオ", 16)
        Size = New-Object Drawing.Size(500, 40)
        Location = New-Object Drawing.Point((($form.ClientSize.Width - 500) / 2), 100)
        Anchor = [System.Windows.Forms.AnchorStyles]::Top
    }
    $form.Controls.Add($textBox)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Text = "OK"
        Font = New-Object Drawing.Font("メイリオ", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($form.ClientSize.Width / 2) - 200), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    $okButton.Add_Click({
        if ([string]::IsNullOrWhiteSpace($textBox.Text)) {
            Show-Error
        } else {
            $form.Tag = $textBox.Text
            $form.Close()
        }
    })
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Text = "キャンセル"
        Font = New-Object Drawing.Font("メイリオ", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($form.ClientSize.Width / 2) + 50), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    }
    $cancelButton.Add_Click({ $form.Close() })
    $form.Controls.Add($cancelButton)

    $form.AcceptButton = $okButton
    $form.ShowDialog()
    return $form
}

# 確認フォームの作成と表示
function Show-ConfirmForm {
    param ([string]$inputText)

    $confirmForm = New-Object Windows.Forms.Form -Property @{
        Text = "入力確認"
        Size = New-Object Drawing.Size(800, 300)
        StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        MaximizeBox = $false
    }

    $label = New-Object Windows.Forms.Label -Property @{
        Text = "入力内容: $inputText`nこの内容でよろしいですか？"
        AutoSize = $true
        Font = New-Object Drawing.Font("メイリオ", 16)
        TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        Dock = [System.Windows.Forms.DockStyle]::Top
        Padding = New-Object Windows.Forms.Padding(0, 20, 0, 20)
    }
    $confirmForm.Controls.Add($label)

    $yesButton = New-Object Windows.Forms.Button -Property @{
        Text = "はい"
        Font = New-Object Drawing.Font("メイリオ", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($confirmForm.ClientSize.Width / 2) - 200), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::Yes
    }
    $yesButton.Add_Click({ $confirmForm.Close() })
    $confirmForm.Controls.Add($yesButton)

    $noButton = New-Object Windows.Forms.Button -Property @{
        Text = "いいえ"
        Font = New-Object Drawing.Font("メイリオ", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($confirmForm.ClientSize.Width / 2) + 50), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::No
    }
    $noButton.Add_Click({ $confirmForm.Close() })
    $confirmForm.Controls.Add($noButton)

    return $confirmForm.ShowDialog()
}

do {
    # 入力フォームを表示し、ユーザーの入力結果とフォームオブジェクトを取得
    $inputForm = Show-InputForm
    $inputResult = $inputForm.DialogResult

    # ユーザーがOKボタンを押し、かつテキストボックスにテキストが入力されている場合の処理
    if ($inputResult -eq [System.Windows.Forms.DialogResult]::OK -and $inputForm.Tag) {
        # 確認フォームを表示し、入力されたテキストを確認するための結果を取得
        $confirmResult = Show-ConfirmForm -inputText $inputForm.Tag

        # ユーザーがYesボタンを押した場合の処理
        if ($confirmResult -eq [System.Windows.Forms.DialogResult]::Yes) {
            # 入力されたテキストをコンソールに表示し、ループを終了
            Write-Host "入力されたテキスト: $($inputForm.Tag)"
            break
        } else {
            # ユーザーがNoボタンを押した場合、入力フォームに戻る旨をコンソールに表示
            Write-Host "入力が確認されませんでした。入力フォームに戻ります。"
        }
    # ユーザーがキャンセルボタンを押した場合の処理
    } elseif ($inputResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
        # キャンセルされた旨をコンソールに表示し、ループを終了
        Write-Host "キャンセルされました。"
        break
    }
} while ($true)  # 常に真の条件でループを継続する
