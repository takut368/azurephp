# Microsoft Graphモジュールのインポート
Import-Module Microsoft.Graph

# Microsoft Graphに接続
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

# 全ユーザーの情報を取得
$users = Get-MgUser -All -Property "Id, UserPrincipalName"

# 項番の初期化
$itemNumber = 1

# 各ユーザーのライセンス情報を取得して表示
foreach ($user in $users) {
    $userId = $user.Id
    $userPrincipalName = $user.UserPrincipalName
    $licenseDetails = Get-MgUserLicenseDetail -UserId $userId

    if ($licenseDetails) {
        Write-Output ("{0}. UPN: {1}" -f $itemNumber, $userPrincipalName)
        $itemNumber++
    }
}
