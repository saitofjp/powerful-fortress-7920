
###
Module dependencies.
###
express = require("express")
routes = require("./routes")
http = require("http")
path = require("path")
socketIo = require("socket.io")
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")


server = http.createServer(app)
io = socketIo.listen(server)

routes.bind app, io


server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

