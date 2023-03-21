const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
    // send a script tag to the client with app.coffee as the entry point
    res.send(`
        <html>
            <head>
                <title>Example</title>
            </head>
            <body>
                <script src="./app.coffee"></script>
            </body>
        </html>
    `)
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})