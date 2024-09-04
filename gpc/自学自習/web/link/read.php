<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>保存されたデータの表示</title>
</head>
<body>

<h1>保存されたデータの表示</h1>

<?php
// 保存されたデータを読み込む
if (file_exists('form_data.json')) {
    $jsonData = file_get_contents('form_data.json');
    $formData = json_decode($jsonData, true);

    if ($formData) {
        echo "<ul>";
        foreach ($formData as $key => $value) {
            echo "<li><strong>$key:</strong> $value</li>";
        }
        echo "</ul>";
    } else {
        echo "<p>データが存在しません。</p>";
    }
} else {
    echo "<p>データファイルが存在しません。</p>";
}
?>

</body>
</html>
