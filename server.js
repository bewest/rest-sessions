// Generated by CoffeeScript 1.6.3
(function() {
  var PORT, app, server;

  app = require("./app");

  PORT = require("./env").port || 8101;

  server = app.listen(PORT);

  console.log("Listening on port " + PORT);

}).call(this);
