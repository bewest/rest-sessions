
app = require "./app"
PORT = require("./env").port || 8101
server = app.listen(PORT)
console.log "Listening on port #{PORT}"
