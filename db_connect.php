<?php
// データベース接続情報
$servername = "server202408.database.windows.net";
$username = "CloudSAc7d4b858@server202408";
$password = "Jnkmn368"; // ここにパスワードを入力
$dbname = "database"; // あなたのデータベース名

// データベース接続の確立
$conn = new mysqli($servername, $username, $password, $dbname);

// 接続エラーチェック
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// URLリダイレクトIDを指定して、その関連URLを取得
$sql = "SELECT destination_url FROM destination_urls WHERE url_redirect_id = 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // データの出力
    while($row = $result->fetch_assoc()) {
        echo "Destination URL: " . $row["destination_url"] . "<br>";
    }
} else {
    echo "0 results";
}

// データベース接続を閉じる
$conn->close();
?>
