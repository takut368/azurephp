<?php
function generateDirectoryHtml($path, $indent = 0) {
    $html = '';
    $items = scandir($path);

    foreach ($items as $item) {
        if ($item == '.' || $item == '..') {
            continue;
        }

        $itemPath = $path . DIRECTORY_SEPARATOR . $item;
        $padding = str_repeat('&nbsp;', $indent * 4);

        // ディレクトリの場合
        if (is_dir($itemPath)) {
            $html .= "<div style='margin-left: {$indent}em;'><b>📁 <a href=\"?dir=" . urlencode($itemPath) . "\">$item</a></b></div>\n";
            $html .= generateDirectoryHtml($itemPath, $indent + 1);
        } else {
            // ファイルの場合
            $fileUrl = str_replace($_SERVER['DOCUMENT_ROOT'], '', $itemPath);
            $html .= "<div style='margin-left: {$indent}em;'>📄 <a href=\"$fileUrl\">$item</a></div>\n";
        }
    }

    return $html;
}

function createHtmlDirectoryStructure($rootDirectory) {
    $htmlTemplate = "
    <!DOCTYPE html>
    <html lang='en'>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>Directory Structure</title>
    </head>
    <body>
        <h1>Directory Structure for $rootDirectory</h1>
        %s
    </body>
    </html>
    ";

    $htmlContent = generateDirectoryHtml($rootDirectory);
    return sprintf($htmlTemplate, $htmlContent);
}

// 現在のディレクトリを取得、クエリパラメータが存在する場合はそのディレクトリを使用
$rootDirectory = isset($_GET['dir']) ? $_GET['dir'] : __DIR__;

// HTMLコンテンツ生成
$htmlOutput = createHtmlDirectoryStructure($rootDirectory);

// 生成されたHTMLを表示
echo $htmlOutput;
?>
