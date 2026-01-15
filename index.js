const ghost = require('ghost');
const path = require('path');

ghost().then((ghostServer) => {
    ghostServer.start();
}).catch((err) => {
    console.error(`Ghost failed to start: ${err.message}`);
    process.exit(1);
});
