// WebSocketサーバとの接続
var socket = new Io();

var vo = document.getElementById('videoout');

socket.on('rtcdl', function (data) {
  vo.src = data;
});
