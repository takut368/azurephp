# アセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-InputForm {
    # フォームの作成
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Input Form"
    $form.Size = New-Object System.Drawing.Size(800, 400)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # ラベルの作成
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Please enter the text:"
    $label.Location = New-Object System.Drawing.Point(300, 50)
    $label.AutoSize = $true
    $label.Font = New-Object System.Drawing.Font("Arial", 16)
    $form.Controls.Add($label)

    # テキストボックスの作成
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(150, 150)
    $textBox.Size = New-Object System.Drawing.Size(500, 40)
    $textBox.Font = New-Object System.Drawing.Font("Arial", 16)
    $form.Controls.Add($textBox)

    # エラーメッセージボックスの作成
    function Show-Error {
        $errorForm = New-Object System.Windows.Forms.Form
        $errorForm.Text = "Error"
        $errorForm.Size = New-Object System.Drawing.Size(400, 200)
        $errorForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

        $errorLabel = New-Object System.Windows.Forms.Label
        $errorLabel.Text = "The input cannot be empty."
        $errorLabel.Size = New-Object System.Drawing.Size(350, 60)
        $errorLabel.Location = New-Object System.Drawing.Point(25, 30)
        $errorLabel.Font = New-Object System.Drawing.Font("Arial", 14)
        $errorLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        $errorForm.Controls.Add($errorLabel)

        $okButton = New-Object System.Windows.Forms.Button
        $okButton.Text = "OK"
        $okButton.Location = New-Object System.Drawing.Point(125, 100)
        $okButton.Size = New-Object System.Drawing.Size(150, 40)
        $okButton.Font = New-Object System.Drawing.Font("Arial", 14)
        $okButton.Add_Click({
            $errorForm.Close()
        })
        $errorForm.Controls.Add($okButton)

        $errorForm.ShowDialog()
    }

    # 確定ボタンの作成
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(200, 250)
    $okButton.Size = New-Object System.Drawing.Size(150, 50)
    $okButton.Font = New-Object System.Drawing.Font("Arial", 16)
    $okButton.Add_Click({
        if ([string]::IsNullOrWhiteSpace($textBox.Text)) {
            Show-Error
        } else {
            $form.Tag = $textBox.Text
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
        }
    })
    $form.Controls.Add($okButton)

    # キャンセルボタンの作成
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(450, 250)
    $cancelButton.Size = New-Object System.Drawing.Size(150, 50)
    $cancelButton.Font = New-Object System.Drawing.Font("Arial", 16)
    $cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })
    $form.Controls.Add($cancelButton)

    # フォームの表示設定（エンターキーでOKボタンを押す）
    $form.AcceptButton = $okButton

    # フォームの表示
    $result = $form.ShowDialog()

    return $form, $result
}

function Show-ConfirmForm {
    param (
        [string]$inputText
    )

    # 確認用フォームの作成
    $confirmForm = New-Object System.Windows.Forms.Form
    $confirmForm.Text = "Confirm Input"
    $confirmForm.Size = New-Object System.Drawing.Size(800, 400)
    $confirmForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

    # 確認ラベルの作成
    $confirmLabel = New-Object System.Windows.Forms.Label
    $confirmLabel.Text = "You entered: $inputText`nIs this correct?"
    $confirmLabel.Location = New-Object System.Drawing.Point(200, 50)
    $confirmLabel.Size = New-Object System.Drawing.Size(400, 100)
    $confirmLabel.Font = New-Object System.Drawing.Font("Arial", 16)
    $confirmLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
    $confirmForm.Controls.Add($confirmLabel)

    # Yesボタンの作成
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.Text = "Yes"
    $yesButton.Location = New-Object System.Drawing.Point(200, 250)
    $yesButton.Size = New-Object System.Drawing.Size(150, 50)
    $yesButton.Font = New-Object System.Drawing.Font("Arial", 16)
    $yesButton.Add_Click({
        $confirmForm.DialogResult = [System.Windows.Forms.DialogResult]::Yes
        $confirmForm.Close()
    })
    $confirmForm.Controls.Add($yesButton)

    # Noボタンの作成
    $noButton = New-Object System.Windows.Forms.Button
    $noButton.Text = "No"
    $noButton.Location = New-Object System.Drawing.Point(450, 250)
    $noButton.Size = New-Object System.Drawing.Size(150, 50)
    $noButton.Font = New-Object System.Drawing.Font("Arial", 16)
    $noButton.Add_Click({
        $confirmForm.DialogResult = [System.Windows.Forms.DialogResult]::No
        $confirmForm.Close()
    })
    $confirmForm.Controls.Add($noButton)

    # 確認フォームの表示
    $confirmResult = $confirmForm.ShowDialog()

    return $confirmResult
}

do {
    # 入力フォームを表示し、ユーザーの入力結果とフォームオブジェクトを取得
    $inputForm, $inputResult = Show-InputForm

    # ユーザーがOKボタンを押し、かつテキストボックスにテキストが入力されている場合の処理
    if ($inputResult -eq [System.Windows.Forms.DialogResult]::OK -and $inputForm.Tag) {
        # 確認フォームを表示し、入力されたテキストを確認するための結果を取得
        $confirmResult = Show-ConfirmForm -inputText $inputForm.Tag

        # ユーザーがYesボタンを押した場合の処理
        if ($confirmResult -eq [System.Windows.Forms.DialogResult]::Yes) {
            # 入力されたテキストをコンソールに表示し、ループを終了
            Write-Host "Entered text: $($inputForm.Tag)"
            break
        } else {
            # ユーザーがNoボタンを押した場合、入力フォームに戻る旨をコンソールに表示
            Write-Host "Input was not confirmed. Returning to input form."
        }
    # ユーザーがキャンセルボタンを押した場合の処理
    } elseif ($inputResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
        # キャンセルされた旨をコンソールに表示し、ループを終了
        Write-Host "Cancelled."
        break
    }
} while ($true)  # 常に真の条件でループを継続する
