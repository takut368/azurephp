#===========================================
#■変数定義
#ユーザープロファイルパス変数定義
$USERPROFILE_PATH = $env:USERPROFILE
#ショートカット配置パス定義
$SHORTCUT_PATH = "C:\work"
#社員番号フォルダー作成場所定義
$TARGET_PATH = "C:\temp"

#ショートカット名定義
$SHORTCUT_NAME = "$SHORTCUT_PATH\Test.lnk"

#【変更不要】wsShellオブジェクト定義
$wsShell = New-Object -ComObject WScript.Shell

#===========================================

# Microsoft.VisualBasicアセンブリを有効化
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
Add-Type -AssemblyName System.Windows.Forms

# 社員番号の入力・判定
do {
    $CONFIRM = "No"

    # 社員番号入力
    $INPUTNum = [Microsoft.VisualBasic.Interaction]::InputBox("社員番号4桁を入力してください", "社員番号入力")

    #入力が空か判定
    if([string]::IsNullOrEmpty($INPUTNum)){
        # 社員番号入力終了メッセージ表示
        $wsShell.popup("社員番号が入力されなかったため終了します。",0,"社員番号入力")
        break
    }elseif([uint16]::TryParse($INPUTNum,[ref]$null) -eq $true -and $INPUTNum.Length -eq "4"){
        # 入力した社員番号が半角数字４桁か判定
        # 社員番号確認メッセージ定義
        $ConfirmMessage = "社員番号は " + $INPUTNum + " で正しいですか？"
        # 社員番号確認ポップアップ表示
        $CONFIRM = [System.Windows.Forms.MessageBox]::Show($ConfirmMessage, "社員番号確認", "YesNo")
    }else{
        # 社員番号再入力メッセージ表示
        $wsShell.popup("社員番号を半角数字４桁で再度入力してください。",0,"社員番号確認")
    }

} while ($CONFIRM -eq "No" ) #社員番号確認が「はい」になるまで社員番号入力を繰り返す


if( ([uint16]::TryParse($INPUTNum,[ref]$null) -eq $true) -and
    ($INPUTNum.Length -eq "4") -and
    ($CONFIRM -eq "Yes")){
#社員番号フォルダ作成
New-Item -Path "$TARGET_PATH\$INPUTNum" -ItemType Directory -ErrorAction SilentlyContinue
#社員番号フォルダのパスを変数へ格納
$EmployeeNumberFolder = "$TARGET_PATH\$INPUTNum"
# ショートカット作成
$Shortcut = $wsShell.CreateShortcut("$SHORTCUT_NAME")
# ショートカットのリンク先指定
$Shortcut.TargetPath = "$EmployeeNumberFolder"
# ショートカットのアイコン指定
$shortcut.IconLocation = "$EmployeeNumberFolder"
# ショートカット設定保存
$Shortcut.Save()
}
