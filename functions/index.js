const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

setGlobalOptions({maxInstances: 10});

exports.helloFlousi = onRequest((request, response) => {
  logger.info("Flousi function called!");

  response.json({
    message: "Hello from Flousi AI backend 🚀",
  });
});
