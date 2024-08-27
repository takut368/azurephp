<?php
require 'vendor/autoload.php';
use GuzzleHttp\Client;

$client = new Client();

$instagramUserId = 'your_instagram_user_id';
$accessToken = 'your_access_token';

$reels = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = $client->request('GET', "https://graph.instagram.com/$instagramUserId/media", [
        'query' => [
            'fields' => 'id,media_type,media_url,thumbnail_url',
            'access_token' => $accessToken,
        ],
    ]);

    $data = json_decode($response->getBody(), true);
    $reels = $data['data'];
}
?>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instagram リールダウンローダー</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 20px;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            text-align: center;
            margin-bottom: 20px;
        }

        input[type="text"] {
            padding: 10px;
            width: 250px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .download-all {
            display: <?= empty($reels) ? 'none' : 'block'; ?>;
            text-align: center;
            margin: 20px 0;
        }

        .reels-list {
            display: <?= empty($reels) ? 'none' : 'flex'; ?>;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .reel-item {
            border: 1px solid #ccc;
            border-radius: 8px;
            overflow: hidden;
            width: 200px;
            text-align: center;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .reel-item img {
            width: 100%;
            height: auto;
        }

        .reel-item button {
            width: 100%;
            padding: 10px;
            background-color: #28a745;
            border: none;
            color: white;
            cursor: pointer;
            border-radius: 0 0 8px 8px;
        }

        .reel-item button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <h1>Instagram リールダウンローダー</h1>
    <form action="" method="post">
        <input type="text" name="username" id="username" placeholder="Instagramユーザー名を入力" required>
        <button type="submit">リールを取得</button>
    </form>
    <?php if (!empty($reels)): ?>
        <div class="download-all">
            <button type="button" onclick="downloadAllReels()">すべてダウンロード</button>
        </div>
        <div class="reels-list">
            <?php foreach ($reels as $reel): ?>
                <div class="reel-item">
                    <img src="<?= htmlspecialchars($reel['thumbnail_url']) ?>" alt="リールサムネイル">
                    <a href="<?= htmlspecialchars($reel['media_url']) ?>" download>ダウンロード</a>
                </div>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</body>
</html>
