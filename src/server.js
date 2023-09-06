const express = require('express');

const port = process.env.PORT || 3000;

const app = express();

app.get('/', (req, res) => {  
    const buildImage = process.env.BUILD_IMAGE || 'localhost';
    const env = process.env.ENVIRONMENT || 'localhost';

    const reponse = {
        'buildImage': buildImage,
        'env': env
    };

    res.json(reponse);
});

app.listen(port, () => console.log(`Listening on port ${port}`));