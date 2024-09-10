<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Redirect</title>
    <script>
        window.onload = function() {
            // 3秒後に外部サイトリンクBに遷移
            setTimeout(function() {
                window.location.href = "https://www.google.com/";
            }, 3000); // 3秒後

            // 8秒後に外部サイトリンクCに遷移
            setTimeout(function() {
                window.location.href = "https://translate.google.com/";
            }, 8000); // 8秒後
        };
    </script>
</head>
<body>
    <p>リンクBに自動遷移し、その後リンクCに自動遷移します。</p>
</body>
</html>
