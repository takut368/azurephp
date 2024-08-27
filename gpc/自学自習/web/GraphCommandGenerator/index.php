<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Microsoft Graph コマンドジェネレータ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            max-width: 600px;
        }
        .button-container {
            margin-bottom: 20px;
        }
        .command-button {
            padding: 10px 20px;
            background-color: #0078d4;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        .command-button:hover {
            background-color: #005a9e;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input[type="text"], select {
            width: calc(100% - 25px);
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="checkbox"] {
            vertical-align: middle;
            margin-left: 5px;
        }
        button.generate {
            padding: 10px 20px;
            background-color: #0078d4;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button.generate:hover {
            background-color: #005a9e;
        }
        pre {
            background-color: #f4f4f4;
            padding: 10px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <h1>Microsoft Graph コマンドジェネレータ</h1>

    <div class="button-container">
        <button class="command-button" onclick="showCommandInputs('createUser')">ユーザー作成</button>
        <button class="command-button" onclick="showCommandInputs('addGroupMember')">グループメンバー追加</button>
        <button class="command-button" onclick="showCommandInputs('createGroup')">グループ作成</button>
    </div>

    <div id="commandInputs"></div>

    <button class="generate" onclick="generateCommand()">コマンドを生成する</button>

    <h2>生成されたコマンド:</h2>
    <pre id="generatedCommand"></pre>

    <script>
        let currentCommand = '';

        function showCommandInputs(commandType) {
            currentCommand = commandType;
            let inputsHtml = '';

            switch (commandType) {
                case 'createUser':
                    inputsHtml += '<label for="userName">ユーザー名:<input type="checkbox" id="userNameVar" onchange="handleCheckboxChange(\'userName\', \'userName\')"></label><input type="text" id="userName">';
                    inputsHtml += '<label for="userPrincipalName">ユーザー UPN (User Principal Name):<input type="checkbox" id="userPrincipalNameVar" onchange="handleCheckboxChange(\'userPrincipalName\', \'userPrincipalName\')"></label><input type="text" id="userPrincipalName">';
                    inputsHtml += '<label for="userPassword">パスワード:<input type="checkbox" id="userPasswordVar" onchange="handleCheckboxChange(\'userPassword\', \'userPassword\')"></label><input type="text" id="userPassword">';
                    break;

                case 'addGroupMember':
                    inputsHtml += '<label for="groupId">グループ ID:<input type="checkbox" id="groupIdVar" onchange="handleCheckboxChange(\'groupId\', \'groupId\')"></label><input type="text" id="groupId">';
                    inputsHtml += '<label for="memberId">メンバー ID:<input type="checkbox" id="memberIdVar" onchange="handleCheckboxChange(\'memberId\', \'memberId\')"></label><input type="text" id="memberId">';
                    break;

                case 'createGroup':
                    inputsHtml += '<label for="groupName">グループ名:<input type="checkbox" id="groupNameVar" onchange="handleCheckboxChange(\'groupName\', \'groupName\')"></label><input type="text" id="groupName">';
                    inputsHtml += '<label for="groupMailNickname">グループのメールニックネーム:<input type="checkbox" id="groupMailNicknameVar" onchange="handleCheckboxChange(\'groupMailNickname\', \'groupMailNickname\')"></label><input type="text" id="groupMailNickname">';
                    break;
            }

            document.getElementById('commandInputs').innerHTML = inputsHtml;
        }

        function handleCheckboxChange(inputId, defaultVarName) {
            const inputField = document.getElementById(inputId);
            const checkbox = document.getElementById(inputId + 'Var');
            
            if (checkbox.checked) {
                if (inputField.value.trim() === '') {
                    inputField.value = '$' + defaultVarName;
                } else if (!inputField.value.startsWith('$')) {
                    inputField.value = '$' + inputField.value;
                }
            } else {
                if (inputField.value.startsWith('$')) {
                    inputField.value = inputField.value.substring(1);
                }
            }
        }

        function generateCommand() {
            let command = '';

            switch (currentCommand) {
                case 'createUser':
                    const userName = document.getElementById('userName').value;
                    const userPrincipalName = document.getElementById('userPrincipalName').value;
                    const userPassword = document.getElementById('userPassword').value;

                    command = `New-MgUser -DisplayName ${userName} -UserPrincipalName ${userPrincipalName} -PasswordProfile @{password=${userPassword}; forceChangePasswordNextSignIn=$true} -AccountEnabled $true`;
                    break;

                case 'addGroupMember':
                    const groupId = document.getElementById('groupId').value;
                    const memberId = document.getElementById('memberId').value;

                    command = `New-MgGroupMember -GroupId ${groupId} -BodyParameter @{ "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/${memberId}" }`;
                    break;

                case 'createGroup':
                    const groupName = document.getElementById('groupName').value;
                    const groupMailNickname = document.getElementById('groupMailNickname').value;

                    command = `New-MgGroup -DisplayName ${groupName} -MailNickname ${groupMailNickname} -GroupTypes "Unified" -MailEnabled $true -SecurityEnabled $false`;
                    break;
            }

            document.getElementById('generatedCommand').innerText = command;
        }
    </script>
</body>
</html>
