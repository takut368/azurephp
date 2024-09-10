<script>
    window.onload = function() {
        // 新しいタブでサイトBを開く
        var siteB = window.open("https://www.google.com/", "_blank");
        
        // 5秒後にサイトCに遷移
        setTimeout(function() {
            window.location.href = "https://translate.google.com/";
        }, 5000); // 5秒後
    };
</script>
