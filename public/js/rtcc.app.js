
// WebSocketサーバに接続する。
var socket = new Io();
var onopen = false;
var send = function(data){
    socket.emit("rtcup", data );
}

var cvs = document.createElement('canvas');
function startCapture(video){

  // 30fps(33msecおき）に画像を取得する。
  // 取得したら、"imageupdate"イベントをfireする。
  timer = setInterval(function(){
    try {
      // キャンバスノードの生成

      cvs.width = video.width;
      cvs.height = video.height;
      var ctx = cvs.getContext('2d');

      // キャンバスに描画
      // 以下のサイズは、Desire用
      // ctx.drawImage(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
      ctx.drawImage(video, 0, 0, video.width, video.height);

      // DataURLを取得し、イベントを発行する
      var data = cvs.toDataURL('image/jpeg');
      send(data);
    } catch(e) {
    }
  }, 1);
}


// chromeの場合、chrome://flags で、

var video = document.getElementById("live")
//for GoogleChrome
navigator.getUserMedia  = navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia;

navigator.getUserMedia(
  { video   : true,
    toString: function() { return 'video'; }
  },
  function(stream) {
    video.src = window.URL.createObjectURL(stream);
    //video.src = stream;
    startCapture(video);
  }
  , function(err) {
    console.log("Unable to get video stream!");
  }
)