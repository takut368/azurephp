<?php
session_start();

// ハッシュ化されたパスワード（"kuramoto" のハッシュ）
$correct_password_hash = '$2y$10$8TZjUqufCCWPG/WW5X6cqOepH/h7IxGDFem3riEMnbdAVHXvVHehi'; // password_hash('kuramoto', PASSWORD_DEFAULT) の結果

// 既にログインしている場合は directory.php にリダイレクト
if (isset($_SESSION['authenticated']) && $_SESSION['authenticated'] === true) {
    header('Location: directory.php');
    exit;
}

// ログインフォームの送信後の処理
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $password = $_POST['password'] ?? '';

    // パスワードが正しいかチェック
    if (password_verify($password, $correct_password_hash)) {
        // 正しければセッションに認証情報を保存
        $_SESSION['authenticated'] = true;
        header('Location: directory.php'); // 認証成功後に directory.php へリダイレクト
        exit;
    } else {
        $error = 'パスワードが間違っています。';
    }
}
?>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>認証ページ</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .login-form { max-width: 400px; margin: 0 auto; background-color: #fff; padding: 20px; border: 1px solid #ccc; border-radius: 5px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
        .login-form h1 { text-align: center; margin-bottom: 20px; }
        .login-form input { width: 100%; padding: 10px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px; }
        .login-form button { width: 100%; padding: 10px; background-color: #0066cc; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .login-form button:hover { background-color: #005bb5; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
    </style>
</head>
<body>

<div class="login-form">
    <h1>パスワード認証</h1>
    <?php if (isset($error)): ?>
        <p class="error"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>
    <form action="" method="post">
        <input type="password" name="password" placeholder="パスワードを入力" required>
        <button type="submit">ログイン</button>
    </form>
</div>

</body>
</html>
