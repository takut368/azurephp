<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>フォーム追加と保存</title>
    <script>
        let count = 1;

        function addForm() {
            count++;
            const formContainer = document.getElementById('formContainer');
            const newForm = document.createElement('div');
            newForm.setAttribute('id', 'formSet' + count);
            newForm.innerHTML = `
                <div>
                    <label>Title: </label>
                    <input type="text" name="title${count}" required><br>

                    <label>飛ばすURL: </label>
                    <input type="url" name="url${count}" required><br>

                    <label>読み取り専用: </label>
                    <input type="text" value="読み取り専用です" readonly><br>

                    <hr>
                </div>
            `;
            formContainer.appendChild(newForm);
        }
    </script>
</head>
<body>

<h1>フォーム追加と保存</h1>

<?php
// データ保存処理
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $formData = [];

    // フォームデータを取得
    foreach ($_POST as $key => $value) {
        $formData[$key] = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
    }

    // データをJSONファイルに保存
    file_put_contents('form_data.json', json_encode($formData, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));

    echo "<p>データが保存されました。</p>";
}
?>

<form method="post">
    <div id="formContainer">
        <div id="formSet1">
            <label>Title: </label>
            <input type="text" name="title1" required><br>

            <label>飛ばすURL: </label>
            <input type="url" name="url1" required><br>

            <label>読み取り専用: </label>
            <input type="text" value="読み取り専用です" readonly><br>

            <hr>
        </div>
    </div>

    <button type="button" onclick="addForm()">追加</button>
    <button type="submit">送信</button>
</form>

</body>
</html>
