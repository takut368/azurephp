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

        if (is_dir($itemPath)) {
            $html .= "<div style='margin-left: {$indent}em;'><b>📁 $item</b></div>\n";
            $html .= generateDirectoryHtml($itemPath, $indent + 1);
        } else {
            $html .= "<div style='margin-left: {$indent}em;'>📄 $item</div>\n";
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

// 使用方法
$rootDirectory = '/path/to/your/directory'; // 対象のディレクトリパスに変更

// HTMLコンテンツ生成
$htmlOutput = createHtmlDirectoryStructure($rootDirectory);

// 生成されたHTMLを表示
echo $htmlOutput;
?>
