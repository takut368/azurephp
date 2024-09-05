<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>フォーム登録とデータ表示</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        h1 {
            text-align: center;
        }
        form, ul {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            background-color: #f9f9f9;
        }
        label, textarea, input {
            display: block;
            width: 100%;
            margin-bottom: 10px;
            box-sizing: border-box;
        }
        input[type="text"], input[type="url"], textarea {
            padding: 8px;
            font-size: 16px;
        }
        button {
            display: block;
            width: 100%;
            padding: 10px;
            font-size: 16px;
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        ul {
            list-style-type: none;
            padding-left: 0;
        }
        ul li {
            margin-bottom: 20px;
        }
        ul li ul li {
            margin-bottom: 5px;
        }
        .remarks {
            display: none;
            padding: 10px;
            background-color: #e9ecef;
            border-left: 4px solid #007BFF;
        }
        .update-button-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .update-button {
            width: 48%;
            margin-left: 10px;
            padding: 10px;
            font-size: 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .update-button:hover {
            background-color: #218838;
        }
        @media (max-width: 768px) {
            form, ul {
                padding: 15px;
            }
            button {
                font-size: 14px;
            }
            .update-button-container {
                flex-direction: column;
            }
            .update-button {
                width: 100%;
                margin: 5px 0;
            }
        }
    </style>
    <script>
        function copyToClipboard(text) {
            const tempInput = document.createElement('input');
            tempInput.style.position = 'absolute';
            tempInput.style.left = '-9999px';
            tempInput.value = text;
            document.body.appendChild(tempInput);
            tempInput.select();
            document.execCommand('copy');
            document.body.removeChild(tempInput);
            alert('クリップボードにコピーしました: ' + text);
        }

        function toggleRemarks() {
            const remarks = document.querySelectorAll('.remarks');
            remarks.forEach(remark => {
                if (remark.style.display === 'none') {
                    remark.style.display = 'block';
                } else {
                    remark.style.display = 'none';
                }
            });
        }

        function refreshData() {
            location.reload(); // ページをリロードして最新のデータを取得
        }
    </script>
</head>
<body>

<h1>登録フォーム</h1>

<?php
// データ保存処理
$filePath = 'form_data.json';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 既存のJSONファイルからデータを読み込む
    $existingData = [];

    if (file_exists($filePath)) {
        $jsonData = file_get_contents($filePath);
        $existingData = json_decode($jsonData, true);
        if (!is_array($existingData)) {
            $existingData = [];
        }
    }

    // 新しいデータを作成
    $formData = [
        'id' => uniqid(),  // 一意な識別子を生成
        'title' => htmlspecialchars($_POST['title'], ENT_QUOTES, 'UTF-8'),
        'url' => htmlspecialchars($_POST['url'], ENT_QUOTES, 'UTF-8'),
        'remarks' => htmlspecialchars($_POST['remarks'], ENT_QUOTES, 'UTF-8'),
        'generated_text' => 'https://example.com/' . uniqid()  // 任意の生成されたテキスト
    ];

    // 新しいデータを既存データに追加
    $existingData[] = $formData;

    // JSONファイルに保存
    file_put_contents($filePath, json_encode($existingData, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT));

    echo "<p>データが保存されました。</p>";
}
?>

<!-- 登録フォーム -->
<form method="post">
    <div id="formSet1">
        <label>Title: </label>
        <input type="text" name="title" required><br>

        <label>飛ばすURL: </label>
        <input type="url" name="url" required><br>

        <label>備考: </label>
        <textarea name="remarks" rows="4" cols="50"></textarea><br>

        <hr>
    </div>

    <button type="submit">登録</button>
</form>

<h1>登録済みデータの表示</h1>

<div class="update-button-container">
    <button type="button" onclick="toggleRemarks()">備考を表示/非表示</button>
    <button class="update-button" type="button" onclick="refreshData()">更新</button>
</div>

<?php
// 保存されたデータを読み込む
if (file_exists($filePath)) {
    $jsonData = file_get_contents($filePath);
    $formData = json_decode($jsonData, true);

    if ($formData) {
        echo "<ul>";
        foreach ($formData as $index => $dataSet) {
            echo "<li><strong>データセット " . ($index + 1) . ":</strong><ul>";
            echo "<li><strong>Title:</strong> " . $dataSet['title'] . "</li>";
            echo "<li><strong>URL:</strong> " . $dataSet['url'] . "</li>";
            echo "<li><strong>Generated URL:</strong> " . $dataSet['generated_text'] . "</li>";
            echo "<li><button type='button' onclick=\"copyToClipboard('" . $dataSet['generated_text'] . "')\">コピー</button></li>";
            echo "<li class='remarks' style='display: none;'><strong>備考:</strong> " . $dataSet['remarks'] . "</li>";
            echo "</ul></li>";
        }
        echo "</ul>";
    } else {
        echo "<p>登録されたデータが存在しません。</p>";
    }
} else {
    echo "<p>データファイルが存在しません。</p>";
}
?>

</body>
</html>
