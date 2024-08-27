# 単語を定義
$word = "hello world!!! who are you??? hello world!!! who are you??? hello world!!! who are you??? hello world!!! who are you??? "
$length = $word.Length

# 単語を構成する各文字を取得
$chars = $word.ToCharArray()

# 各段階での出力を保持する変数
$current = ""

for ($i = 0; $i -lt $length; $i++) {
    # ASCIIで'a'から'z'と記号
    foreach ($c in 97..122 + 32 + 33 + 63) {
        $char = [char]$c
        $output = $current + $char

        # 現在の文字を出力
        Write-Host $output
        # Start-Sleep -Milliseconds 50

        # 単語と一致するかチェック
        if ($output -eq $word.Substring(0, $i + 1)) {
            # 次の文字に進むために現在の出力を更新
            $current = $output
            break
        }
    }
}
