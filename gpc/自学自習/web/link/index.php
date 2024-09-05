<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>フォーム登録とデータ表示</title>
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
    $formData = [];
    foreach ($_POST as $key => $value) {
        $formData[$key] = htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
    }

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

        <label>読み取り専用: </label>
        <input type="text" value="読み取り専用です" readonly><br>

        <hr>
    </div>

    <button type="submit">登録</button>
</form>

<h1>登録済みデータの表示</h1>

<?php
// 保存されたデータを読み込む
if (file_exists($filePath)) {
    $jsonData = file_get_contents($filePath);
    $formData = json_decode($jsonData, true);

    if ($formData) {
        echo "<ul>";
        foreach ($formData as $index => $dataSet) {
            echo "<li><strong>データセット " . ($index + 1) . ":</strong><ul>";
            foreach ($dataSet as $key => $value) {
                echo "<li><strong>$key:</strong> $value</li>";
            }
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
