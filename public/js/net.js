socket = new Ws()

var maxScale = d3.scale.linear().range([ 1, 200 ]),
    max = 0;

var doc = document.documentElement
var w = doc.clientWidth-20
var h = doc.clientHeight-20

var nodes = [],    //ノードを収める配列
    links = [],    //ノード間のリンク情報を収める配列
    map = {};

var fill = d3.scale.category20();

//グラフを描画するステージ（svgタグ）を追加

var stage = d3.select("body").append("svg:svg").attr("width", w).attr("height", h)
  .append("g")
  ;

//グラフの初期設定
var force = self.force = d3.layout.force()
    .nodes(nodes)
    .links(links)
    .gravity(1) //重力
    .distance(function(d,i){
      return 1;
    }) //ノード間の距離
    .charge(-100) //各ノードの引き合うor反発しあう力
    .size([w, h]); //図のサイズ
 
////グラフにアニメーションイベントを設置
force.on("tick", function() {
    var node = stage.selectAll("g.node").data(nodes, function(d) { return d.id_str;} );
        node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });

    var link = stage.selectAll("line.link").data(links, function(d) { return d.source.id_str + ',' + d.target.id_str});
        link.attr({
            x1: function(d) { return d.source.x; },
            y1: function(d) { return d.source.y; },
            x2: function(d) { return d.target.x; },
            y2:function(d) { return d.target.y; }
        });
});


//アップデート（再描画）
function update() {
    var link = stage.selectAll("line.link")
    .data(links, function(l) { return l.source.id_str + '-' + l.target.id_str; }); //linksデータを要素にバインド
     
    link.enter().append("svg:line")
      .attr("class", "link")
      .attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });
 
    link.exit().remove(); //要らなくなった要素を削除
 
    var node = stage.selectAll("g.node")
        .data(nodes, function(d) { return d.id_str;});  //nodesデータを要素にバインド
 
    var nodeEnter = node.enter().append("svg:g")
        .attr("class", "node")
        .call(force.drag); //ノードをドラッグできるように設定
     
    nodeEnter.append("circle")
            .attr("class", "circle")
            .attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; })
            .style("fill", function(d, i) { return fill(i); })
          .attr("r", function(d) {
                return 6
            } )
            .on("mouseover", function(d){ console.log(d)});

//    nodeEnter.append("svg:text")
//    .attr("class", "nodetext")
//    .attr("dx", 18)
//    .attr("dy", ".35em")
//    .text(function(d) { if(d.rt) return  d.text });
 
    node.exit().remove(); //要らなくなった要素を削除
 
    force.start(); //forceグラグの描画を開始
 
}
 
var ps4 = { text:"PS4", time:1 };

//ノード、リンクの初期値
function forceInit() {
    var nA = {id_str: 'a', time : 1 };
    var nB = {id_str: 'b', time : 2 };
    var nC = {id_str: 'c',  time :3 } ;
    var nD = {id_str: 'd', time :4 };
    nodes.push(ps4);
    nodes.push(nA);
    nodes.push(nB);
    nodes.push(nC);
    nodes.push(nD);
 
    var lAB = {source: nA, target: nB};
    var lAC = {source: nA, target: nC};
    var lBC = {source: nB, target: nC};
    var lAD = {source: nA, target: nD};
    links.push(lAB );
    links.push(lAC);
    links.push(lBC);
    links.push(lAD);
 
    update();
}


socket.on("tw",  function (tw) {
  tw.time = 1;
  map[tw.id_str] = tw;
  nodes.push(tw);

  if(tw.retweeted_status) {

    var rtw = map[tw.retweeted_status.id_str];
    if ( !rtw ) {
      map[tw.retweeted_status.id_str] = tw.retweeted_status;
      rtw =  tw.retweeted_status;
      if (max < rtw.retweet_count ) {
        max = rtw.retweet_count;
      }
      rtw.time = 1;
      rtw.rt = true;
      nodes.push(rtw)
    }
    if( !rtw.rt ) {
      console.log(rtw)
    }
    links.push({
      source : rtw,
      target : tw
    })
  }
  update();
});


/*
 * .filterメソッドは、配列に対して反復処理を行い、その結果を新しい配列として返す
*/

forceInit();
