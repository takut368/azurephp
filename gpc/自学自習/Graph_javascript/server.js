const express = require('express');
const axios = require('axios');
const path = require('path');

const app = express();
const port = 3000;

// Azure AD情報
const clientId = 'YOUR_CLIENT_ID';
const tenantId = 'YOUR_TENANT_ID';
const clientSecret = 'YOUR_CLIENT_SECRET';

const tokenEndpoint = `https://login.microsoftonline.com/${tenantId}/oauth2/v2.0/token`;

// 静的ファイルの提供
app.use(express.static(path.join(__dirname, 'public')));

// JSONとURLエンコードされたデータの解析
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.post('/get-token', async (req, res) => {
    const reqTokenBody = new URLSearchParams({
        client_id: clientId,
        scope: 'https://graph.microsoft.com/.default',
        client_secret: clientSecret,
        grant_type: 'client_credentials',
    });

    try {
        const tokenResponse = await axios.post(tokenEndpoint, reqTokenBody.toString(), {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
        });
        res.json({ token: tokenResponse.data.access_token });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// サーバーの起動
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

