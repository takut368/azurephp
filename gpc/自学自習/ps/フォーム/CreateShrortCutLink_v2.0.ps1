#===========================================
#■変数定義
#環境変数パス定義
#$ENV_PATH = $env:USERPROFILE #環境変数から'％'を除いた文字列を「$env:」のあとに記載することで指定可能
#ユーザープロファイルパス変数定義
$USERPROFILE_PATH = $env:USERPROFILE
#ショートカット配置パス定義
$SHORTCUT_PATH = "$USERPROFILE_PATH\desktop"

#社員番号フォルダー場所定義
$TARGET_PATH = "C:\temp"

#【変更不要】wsShellオブジェクト定義
$wsShell = New-Object -ComObject WScript.Shell

#【変更不要】ターゲットパス確認定義
$TargetCheckResult = Test-Path $TARGET_PATH
#===========================================

Add-Type -AssemblyName System.Windows.Forms

do {
    # フォームの作成
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "社員番号入力"
    $form.Width = 300
    $form.Height = 150

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "社員番号4桁を入力してください:"
    $label.Top = 20
    $label.Left = 10
    $label.Width = 280

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Top = 50
    $textBox.Left = 10
    $textBox.Width = 260

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = 80
    $okButton.Height = 30
    $okButton.Top = 80
    $okButton.Left = 30
    $okButton.Add_Click({
        $inputNum = $textBox.Text
        if ([uint16]::TryParse($inputNum, [ref]$null) -and $inputNum.Length -eq 4) {
            # 確認メッセージ
            $confirmMessage = "社員番号は $inputNum で正しいですか？"
            $confirmResult = [System.Windows.Forms.MessageBox]::Show($confirmMessage, "社員番号確認", [System.Windows.Forms.MessageBoxButtons]::YesNo)
            if ($confirmResult -eq [System.Windows.Forms.DialogResult]::Yes) {
                $employeeFolder = "$TARGET_PATH\$inputNum"
                if (Test-Path $employeeFolder) {
                    # フォルダが存在する場合、ショートカットを作成
                    $global:EmployeeNumber = $inputNum
                    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
                    $form.Close()
                } else {
                    # フォルダが存在しない場合、エラーメッセージを表示して再入力を促す
                    [System.Windows.Forms.MessageBox]::Show("社員番号フォルダが存在しません。再度入力してください。", "エラー", [System.Windows.Forms.MessageBoxButtons]::OK)
                }
            } else {
                # Noならフォームを再表示
                $form.DialogResult = [System.Windows.Forms.DialogResult]::Retry
                $form.Close()
            }
        } else {
            # 入力が不正ならエラーメッセージ
            [System.Windows.Forms.MessageBox]::Show("社員番号を半角数字4桁で再度入力してください。", "入力エラー")
        }
    })

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "キャンセル"
    $cancelButton.Width = 80
    $cancelButton.Height = 30
    $cancelButton.Top = 80
    $cancelButton.Left = 140
    $cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })

    $form.Controls.Add($label)
    $form.Controls.Add($textBox)
    $form.Controls.Add($okButton)
    $form.Controls.Add($cancelButton)

    # フォームの表示
    $result = $form.ShowDialog()

} while ($result -eq [System.Windows.Forms.DialogResult]::Retry)

# フォーム結果に基づく処理
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $inputNum = $global:EmployeeNumber
    $employeeNumberFolder = "$TARGET_PATH\$inputNum"
    $shortcutPath = [System.IO.Path]::Combine($SHORTCUT_PATH, "$inputNum.lnk")
    # ショートカット作成
    $shortcut = $wsShell.CreateShortcut($shortcutPath)
    # ショートカットのリンク先指定
    $shortcut.TargetPath = "$employeeNumberFolder"
    # ショートカットのアイコン指定
    $shortcut.IconLocation = "$employeeNumberFolder"
    # ショートカット設定保存
    $shortcut.Save()
} else {
    Write-Host "処理がキャンセルされました。"
}
