# WebSocketサーバとの接続
socket = new Io()
vo = document.getElementById("videoout")
socket.on "rtcdl", (data) -> vo.src = data

