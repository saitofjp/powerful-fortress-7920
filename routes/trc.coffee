exports.bind = (app, io) ->

  io.sockets.on "connection", (socket) ->
    socket.on "rtcup", (data) ->
      io.sockets.emit "rtcdl", data
