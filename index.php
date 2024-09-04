<?php
// 初期設定
$directory = isset($_GET['dir']) ? $_GET['dir'] : '.';
$sort = isset($_GET['sort']) ? $_GET['sort'] : 'name';
$search = isset($_GET['search']) ? $_GET['search'] : '';

// ディレクトリが安全か確認（ディレクトリトラバーサル攻撃を防ぐ）
$realBase = realpath('.');
$realUserPath = realpath($directory);
if ($realUserPath === false || strpos($realUserPath, $realBase) !== 0) {
    die("不正なディレクトリへのアクセス");
}

// ディレクトリ内のフォルダとファイルを取得
$files = scandir($directory);

// 検索フィルタ
if ($search !== '') {
    $files = array_filter($files, function($file) use ($search) {
        return stripos($file, $search) !== false;
    });
}

// ソート処理
if ($sort === 'name') {
    usort($files, function($a, $b) use ($directory) {
        return strcmp($a, $b);
    });
} elseif ($sort === 'date') {
    usort($files, function($a, $b) use ($directory) {
        return filemtime($directory . '/' . $b) - filemtime($directory . '/' . $a); // 日付順
    });
}

// フォルダ・ファイル作成処理
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['newFolder'])) {
        $newFolder = $directory . DIRECTORY_SEPARATOR . basename($_POST['newFolder']);
        if (!file_exists($newFolder)) {
            mkdir($newFolder);
            echo "フォルダが作成されました。";
        } else {
            echo "そのフォルダは既に存在しています。";
        }
    }

    if (isset($_FILES['newFile'])) {
        $uploadDir = $directory . DIRECTORY_SEPARATOR;
        $uploadFile = $uploadDir . basename($_FILES['newFile']['name']);
        if (move_uploaded_file($_FILES['newFile']['tmp_name'], $uploadFile)) {
            echo "ファイルがアップロードされました。";
        } else {
            echo "アップロードに失敗しました。";
        }
    }
}

// ヘッダーのHTML
echo '<!DOCTYPE html>';
echo '<html lang="ja">';
echo '<head>';
echo '<meta charset="UTF-8">';
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0">';
echo '<title>ディレクトリ一覧</title>';
echo '<style>';
echo 'body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f4f4f4; }';
echo '.explorer { max-width: 800px; margin: 0 auto; border: 1px solid #ccc; background-color: #fff; padding: 20px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }';
echo '.explorer h1 { font-size: 24px; margin-bottom: 20px; }';
echo '.explorer a { text-decoration: none; color: #0066cc; display: block; padding: 5px 10px; margin: 5px 0; background-color: #f9f9f9; border-radius: 4px; }';
echo '.explorer a:hover { background-color: #e9e9e9; }';
echo '.actions { margin-bottom: 20px; }';
echo 'input[type="text"], input[type="file"] { padding: 5px; margin-right: 10px; }';
echo 'input[type="submit"], button { padding: 5px 10px; background-color: #0066cc; color: white; border: none; border-radius: 4px; cursor: pointer; }';
echo 'input[type="submit"]:hover, button:hover { background-color: #004f99; }';
echo '</style>';
echo '</head>';
echo '<body>';
echo '<div class="explorer">';
echo '<h1>フォルダ: ' . htmlspecialchars($directory) . '</h1>';

// 検索フォーム
echo '<div class="actions">';
echo '<form method="GET">';
echo '<input type="hidden" name="dir" value="' . htmlspecialchars($directory) . '">';
echo '<input type="text" name="search" placeholder="検索..." value="' . htmlspecialchars($search) . '">';
echo '<input type="submit" value="検索">';
echo '</form>';
echo '</div>';

// ソートフォーム
echo '<div class="actions">';
echo '<form method="GET">';
echo '<input type="hidden" name="dir" value="' . htmlspecialchars($directory) . '">';
echo '<label>ソート: </label>';
echo '<button type="submit" name="sort" value="name"' . ($sort === 'name' ? ' disabled' : '') . '>名前順</button>';
echo '<button type="submit" name="sort" value="date"' . ($sort === 'date' ? ' disabled' : '') . '>日付順</button>';
echo '</form>';
echo '</div>';

// フォルダ作成フォーム
echo '<div class="actions">';
echo '<form method="POST">';
echo '<input type="text" name="newFolder" placeholder="新しいフォルダ名">';
echo '<input type="submit" value="フォルダ作成">';
echo '</form>';
echo '</div>';

// ファイルアップロードフォーム
echo '<div class="actions">';
echo '<form method="POST" enctype="multipart/form-data">';
echo '<input type="file" name="newFile">';
echo '<input type="submit" value="ファイルアップロード">';
echo '</form>';
echo '</div>';

// 戻るリンク
if ($directory !== '.') {
    $parentDir = dirname($directory);
    echo '<li><a href="?dir=' . urlencode($parentDir) . '">⏪ 上のフォルダに戻る</a></li>';
}

// フォルダとファイルの表示
echo '<ul>';
foreach ($files as $file) {
    if ($file === '.' || $file === '..') {
        continue;
    }

    $fullPath = $directory . DIRECTORY_SEPARATOR . $file;
    if (is_dir($fullPath)) {
        echo '<li><a href="?dir=' . urlencode($fullPath) . '">📁 ' . htmlspecialchars($file) . '</a></li>';
    } else {
        echo '<li><a href="' . urlencode($fullPath) . '" target="_blank">📄 ' . htmlspecialchars($file) . '</a></li>';
    }
}
echo '</ul>';
echo '</div>';
echo '</body>';
echo '</html>';
?>
