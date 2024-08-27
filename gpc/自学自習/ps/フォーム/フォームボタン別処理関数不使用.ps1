#===========================================
#■変数定義
#ユーザープロファイルパス変数定義
$USERPROFILE_PATH = $env:USERPROFILE
#ショートカット配置パス定義
$SHORTCUT_PATH = "$USERPROFILE_PATH\desktop"
#社員番号フォルダー作成場所定義
$TARGET_PATH = "C:\temp"

#ショートカット名定義
$SHORTCUT_NAME = "$SHORTCUT_PATH\Test.lnk"

#【変更不要】wsShellオブジェクト定義
$wsShell = New-Object -ComObject WScript.Shell

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
                # 確認がYesならフォームを閉じて後続処理へ
                $global:EmployeeNumber = $inputNum
                $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
                $form.Close()
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
    # 社員番号フォルダ作成
    New-Item -Path "$TARGET_PATH\$inputNum" -ItemType Directory -ErrorAction SilentlyContinue
    # 社員番号フォルダのパスを変数へ格納
    $employeeNumberFolder = "$TARGET_PATH\$inputNum"
    # ショートカット作成
    $shortcut = $wsShell.CreateShortcut("$SHORTCUT_NAME")
    # ショートカットのリンク先指定
    $shortcut.TargetPath = "$employeeNumberFolder"
    # ショートカットのアイコン指定
    $shortcut.IconLocation = "$employeeNumberFolder"
    # ショートカット設定保存
    $shortcut.Save()
} else {
    Write-Host "処理がキャンセルされました。"
}
