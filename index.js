const ghost = require('ghost');
const path = require('path');

ghost({
    config: path.join(__dirname, 'config.production.json')
}).then((ghostServer) => {
    ghostServer.start();
});
