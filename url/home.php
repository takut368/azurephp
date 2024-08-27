<?php
// データベース接続情報
$servername = "server202408.database.windows.net";
$username = "CloudSAc7d4b858@server202408";
$password = "Jnkmn368"; // 提供されたパスワード
$dbname = "database"; // 確認されたデータベース名

// mysqliクラスのオブジェクトを作成
$mysqli = new mysqli($servername, $username, $password, $dbname);

// 接続エラーチェック
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
} else {
    $mysqli->set_charset("utf8");
}

// フォームが送信された場合の処理
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // SourceURLの生成
    $source_url = "https://example.com/" . uniqid(); // ユニークIDでSourceURLを生成
    
    // url_redirectsテーブルにSourceURLを挿入
    $stmt = $mysqli->prepare("INSERT INTO url_redirects (source_url) VALUES (?)");
    $stmt->bind_param("s", $source_url);
    $stmt->execute();
    $url_redirect_id = $stmt->insert_id;
    $stmt->close();

    // destination_urlsテーブルに複数のDestinationURLを挿入
    foreach ($_POST['destination_url'] as $destination_url) {
        if (!empty($destination_url)) {
            $stmt = $mysqli->prepare("INSERT INTO destination_urls (url_redirect_id, destination_url) VALUES (?, ?)");
            $stmt->bind_param("is", $url_redirect_id, $destination_url);
            $stmt->execute();
            $stmt->close();
        }
    }

    // SourceURLを表示
    echo "登録が完了しました。<br>";
    echo "生成されたSourceURL: <a href='$source_url' target='_blank'>$source_url</a><br>";
}

// データベース接続を閉じる
$mysqli->close();
?>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>URLリダイレクト管理</title>
</head>
<body>
    <h1>DestinationURL登録とSourceURL発行</h1>
    <form method="post">
        <div id="url-fields">
            <input type="text" name="destination_url[]" placeholder="Destination URLを入力">
        </div>
        <button type="button" onclick="addField()">URLを追加</button>
        <br><br>
        <input type="submit" value="登録してSourceURLを発行">
    </form>

    <script>
        function addField() {
            var div = document.createElement('div');
            div.innerHTML = '<input type="text" name="destination_url[]" placeholder="Destination URLを入力">';
            document.getElementById('url-fields').appendChild(div);
        }
    </script>
</body>
</html>
