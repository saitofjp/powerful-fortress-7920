// Generated by CoffeeScript 1.7.1
(function() {
  var socket, vo;

  socket = new Io();

  vo = document.getElementById("videoout");

  socket.on("rtcdl", function(data) {
    return vo.src = data;
  });

}).call(this);

//# sourceMappingURL=rtcd.app.map
