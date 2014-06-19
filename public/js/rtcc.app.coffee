# WebSocketサーバに接続する。
socket = new Io()
cvs = document.createElement("canvas")
video = document.getElementById("live")

send = (data) ->
  socket.emit "rtcup", data

startCapture = (video) ->
  # 30fps(33msecおき）に画像を取得する。
  # 取得したら、"imageupdate"イベントをfireする。
  timer = setInterval ->
    try

    # キャンバスノードの生成
      cvs.width = video.width
      cvs.height = video.height
      ctx = cvs.getContext("2d")

      # キャンバスに描画
      # 以下のサイズは、Desire用
      # ctx.drawImage(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
      ctx.drawImage video, 0, 0, video.width, video.height

      # DataURLを取得し、イベントを発行する
      data = cvs.toDataURL("image/jpeg")
      send data
  , 1


#for GoogleChrome
navigator.getUserMedia = navigator.getUserMedia or
  navigator.webkitGetUserMedia or
  navigator.mozGetUserMedia or
  navigator.msGetUserMedia

navigator.getUserMedia {
    video: true
    toString: -> "video"
  }
, (stream) ->
  video.src = window.URL.createObjectURL(stream)

  #video.src = stream;
  startCapture video

, (err) ->
  console.log "Unable to get video stream!"
