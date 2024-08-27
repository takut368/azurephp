<?php
// データベース接続情報
$servername = "server202408.database.windows.net"; // サーバー名に .database.windows.net を追加します
$username = "CloudSAc7d4b858"; // SQLサーバーの管理者ユーザー名
$password = "Jnkmn368"; // 管理者パスワード
$dbname = "database"; // データベース名

// 接続の確立
$conn = new mysqli($servername, $username, $password, $dbname);

// 接続確認
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connected successfully to the database.";
}

// 継続するアプリケーションロジック
?>
