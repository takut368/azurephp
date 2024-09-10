<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>Redirect</title>
    <script>
        function openSiteB() {
            // サイトBを新しいタブで開く
            var siteB = window.open("https://www.google.com/", "_blank");

            // 5秒後に元のウィンドウでサイトCに遷移
            setTimeout(function() {
                window.location.href = "https://translate.google.com/";
            }, 5000); // 5秒後
        }
    </script>
</head>
<body>
    <p>リンクBに遷移し、その後リンクCに遷移します。</p>
    <button onclick="openSiteB()">リダイレクト開始</button>
</body>
</html>
