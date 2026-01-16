const ghost = require('ghost');
const express = require('express');

ghost().then((ghostServer) => {
    // Add health check endpoint for Railway
    ghostServer.rootApp.get('/health', (req, res) => {
        res.status(200).send('OK');
    });

    ghostServer.start().then(() => {
        console.log('Ghost started successfully with health check at /health');
    });
}).catch((err) => {
    console.error(`Ghost failed to start: ${err.message}`);
    process.exit(1);
});
