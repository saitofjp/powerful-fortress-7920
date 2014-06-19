
maxScale = d3.scale.linear().range([ 1 ,200 ])
max = 0

doc = document.documentElement
w = doc.clientWidth - 20
h = doc.clientHeight - 20

nodes = [] #ノードを収める配列
links = [] #ノード間のリンク情報を収める配列
map = {}

fill = d3.scale.category20()

#グラフを描画するステージ（svgタグ）を追加
stage = d3.select("body")
  .append("svg:svg")
  .attr("width", w)
  .attr("height", h)
  .append("g")

#グラフの初期設定
force = self.force = d3.layout.force()
  .nodes(nodes)
  .links(links)
  .gravity(1) #重力
  .distance (d,i) -> 1 #ノード間の距離
  .charge(-100) #各ノードの引き合うor反発しあう力
  .size([w, h]) #図のサイズ

#グラフにアニメーションイベントを設置
force.on "tick", ->
  node = stage.selectAll("g.node")
    .data(nodes, (d) -> d.id_str )

  node.attr "transform", (d) -> "translate( #{d.x} , #{d.y} )"

  link = stage.selectAll("line.link")
    .data(links, (d) ->
      d.source.id_str + "," + d.target.id_str
    )

  link.attr
    x1: (d) -> d.source.x
    y1: (d) -> d.source.y
    x2: (d) -> d.target.x
    y2: (d) -> d.target.y



#アップデート（再描画）
update = ->
  link = stage.selectAll("line.link")
    .data(links, (l) -> #linksデータを要素にバインド
      l.source.id_str + "-" + l.target.id_str
    )

  link.enter().append("svg:line")
    .attr "class", "link"
    .attr "x1", (d) -> d.source.x
    .attr "y1", (d) -> d.source.y
    .attr "x2", (d) -> d.target.x
    .attr "y2", (d) -> d.target.y

  link.exit().remove() #要らなくなった要素を削除

  node = stage.selectAll("g.node")
    .data(nodes, (d) ->
      d.id_str
    )#nodesデータを要素にバインド

  nodeEnter = node.enter().append("svg:g")
    .attr("class", "node")
    .call(force.drag) #ノードをドラッグできるように設定

  nodeEnter.append("circle")
    .attr("class", "circle")
    .attr("cx", (d) -> d.x)
    .attr("cy", (d) -> d.y)
    .style("fill", (d, i) ->  fill(i) )
    .attr("r", (d) -> 6 )
    .on "mouseover", (d) -> console.log d

  #    nodeEnter.append("svg:text")
  #    .attr("class", "nodetext")
  #    .attr("dx", 18)
  #    .attr("dy", ".35em")
  #    .text(function(d) { if(d.rt) return  d.text });

  node.exit().remove() #要らなくなった要素を削除
  force.start() #forceグラグの描画を開始

ps4 =
  text: "PS4"
  time: 1

forceInit = ->
  nA = {id_str: 'a', time : 1 };
  nB = {id_str: 'b', time : 2 };
  nC = {id_str: 'c',  time :3 } ;
  nD = {id_str: 'd', time :4 };

  nodes.push ps4
  nodes.push nA
  nodes.push nB
  nodes.push nC
  nodes.push nD

  lAB = {source: nA, target: nB};
  lAC = {source: nA, target: nC};
  lBC = {source: nB, target: nC};
  lAD = {source: nA, target: nD};

  links.push lAB
  links.push lAC
  links.push lBC
  links.push lAD
  update()

socket = new Ws()
socket.on "tw", (tw) ->
  tw.time = 1
  map[tw.id_str] = tw
  nodes.push tw
  if tw.retweeted_status
    rtw = map[tw.retweeted_status.id_str]
    unless rtw
      map[tw.retweeted_status.id_str] = tw.retweeted_status
      rtw = tw.retweeted_status

      if max < rtw.retweet_count
        max = rtw.retweet_count

      rtw.time = 1
      rtw.rt = true
      nodes.push rtw
    unless rtw.rt
      console.log rtw
    links.push
      source: rtw
      target: tw
  update()

forceInit();
