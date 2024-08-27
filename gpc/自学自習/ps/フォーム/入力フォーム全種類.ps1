# パラメータ定義はスクリプトの最初に配置
param (
    [string]$Name
)

# 必要なアセンブリの読み込み
Add-Type -AssemblyName System.Windows.Forms

# 1. パラメータの使用
if ($Name) {
    Write-Host "Entered name via parameter: $Name"
}
else {
    Write-Host "No parameter provided."
}

# 2. 環境変数の使用
if ($env:USERNAME_INPUT) {
    $Name = $env:USERNAME_INPUT
    Write-Host "Entered name via environment variable: $Name"
}
else {
    Write-Host "No environment variable found."
}

# 3. ファイルの使用
$nameFile = "name.txt"
if (Test-Path $nameFile) {
    $Name = Get-Content -Path $nameFile
    Write-Host "Entered name via file: $Name"
}
else {
    Write-Host "No file found."
}

# 4. コンソール入力の使用
$consoleName = Read-Host "Please enter your name (Console)"
Write-Host "Entered name via console: $consoleName"
if ($consoleName) {
    $Name = $consoleName
    Set-Content -Path $nameFile -Value $Name
    $env:USERNAME_INPUT = $Name
}

# 5. メッセージボックスの使用
$result = [System.Windows.Forms.MessageBox]::Show("Do you want to proceed to the next input method?", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo)
if ($result -eq [System.Windows.Forms.DialogResult]::No) {
    Write-Host "You selected No."
}
else {
    Write-Host "You selected Yes."
}

# 6. PowerShell ISEのプロンプトを使用する方法
$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes description")
    (New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No description")
    (New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel", "Cancel description")
)

$choiceResult = $host.ui.PromptForChoice("Title", "Please choose an option:", $choices, 0)
switch ($choiceResult) {
    0 { Write-Host "You selected Yes." }
    1 { Write-Host "You selected No." }
    2 { Write-Host "You selected Cancel." }
}

# 7. GUIフォームの使用
$form = New-Object System.Windows.Forms.Form
$form.Text = "Input Form"
$form.Width = 350
$form.Height = 180
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# ラベルの作成
$label = New-Object System.Windows.Forms.Label
$label.Text = "Please enter your name:"
$label.AutoSize = $true
$label.Top = 20
$label.Left = 20
$form.Controls.Add($label)

# テキストボックスの作成
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Top = 50
$textBox.Left = 20
$textBox.Width = 300
$form.Controls.Add($textBox)

# 確定ボタンの作成
$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Top = 90
$okButton.Left = 80
$okButton.Width = 80
$okButton.Add_Click({
        $form.Tag = $textBox.Text
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
$form.Controls.Add($okButton)

# キャンセルボタンの作成
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Top = 90
$cancelButton.Left = 190
$cancelButton.Width = 80
$cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })
$form.Controls.Add($cancelButton)

# フォームの表示設定（エンターキーでOKボタンを押す）
$form.AcceptButton = $okButton

# フォームの表示
$formResult = $form.ShowDialog()

# 入力値の表示（または他の処理）
if ($formResult -eq [System.Windows.Forms.DialogResult]::OK -and $form.Tag) {
    $Name = $form.Tag
    Write-Host "Entered name via GUI form: $Name"
    Set-Content -Path $nameFile -Value $Name
    $env:USERNAME_INPUT = $Name
}
else {
    Write-Host "Cancelled."
}

# 最終的な入力内容をコンソールに表示
if ($Name) {
    Write-Host "Final entered name: $Name"
}
else {
    Write-Host "No name entered."
}
