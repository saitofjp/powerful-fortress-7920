var config = $.extend(true, {
  maxItems :500,
  wordMin:2,
  delay:10
}, JSON.parse(window.location.hash.replace("#","") || "{}"))

toastr.options. positionClass =  "toast-bottom-full-width";

var repo = new WordRepo(config);
var retweets =[];

var socket = new Ws();
socket.on('tw', function calc(tw) {
  retweets.push(tw.retweeted_status)
  repo.push(tw.text);
});

socket.on('msg', function (data) {
  toastr.warning(  data );
});

setInterval(function(){
  var r = retweets.shift();
  if(r){
    toastr.info("<img src='"+ r.profile_image_url+"'>&nbsp;"+ r.text + "&nbsp;["+ r.retweet_count+"]");
  }
},1000);



(function( width , height ) {
  var colorScale = d3.scale.category20();
  var random = d3.random.irwinHall(2);

  var svg = d3.select("svg")
    .attr({
      "width": width,
      "height": height
    })
    .append("g")
      .attr("transform", "translate(" + [width >> 1, height >> 1] + ")");

  var layout  = d3.layout.cloud()
      .size([width, height])
      .words([{}])
      .rotate(function() { return Math.round(1-random()) * 90; }) //ランダムに文字を90度回転
      .font("Impact")
      .fontSize(function(d) { return d.size; })
      .on("end", function(words){ _.defer(draw ,words) }) //描画関数の読み込み

  //描画更新
  var update = _.debounce(function (){

    var datas = repo.getAsArray()
      .slice(0,config.maxItems);

    var countMax = d3.max(datas, function(d){ return d.count} );
    var sizeScale = d3.scale.linear().domain([0, countMax]).range([30, 500])

    var words = datas.map(function(d) {
        return {
          text: d.word,
          size: sizeScale(d.count) //頻出カウントを文字サイズに反映
        };
      })
      .filter(function(v){ return v});

    //レイアウトに叩き込んで再計算
    layout.words(words).start();
  },1000);

  //描画する
  function draw(words) {
    var node = svg.selectAll("text")
      .data(words, function(d) { return d.text; }); //第二引数はキーになる

    //削除されたノード
    node.exit().remove();

    //既存のノード
    node.transition() //アニメーション
          .delay(function(d, i) { return i * config.delay ; })
          .duration(1000)
          .attr("transform", function(d) { return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")"; })
          .style({
              "font-size":function(d) { return d.size + "px"; }
            })
          .each("end",update)

    //追加されたノード
    node.enter()
      .append("text")
      .style({
           "font-family": "Impact",
           "font-size":function(d) { return d.size + "px"; },
           "fill": function(d, i) { return colorScale(i); }
       })
      .attr({
          "text-anchor":"middle",
          "transform": function(d) {
              return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
          }
      })
      .text(function(d) { return d.text; })

      _.delay(update, 1000);
  }

  update();
})(
    document.documentElement.clientWidth-20,
    document.documentElement.clientHeight-20
)