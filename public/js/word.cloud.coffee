class WordCloud
  constructor: (@config, @repo) ->
    #便利関数を定義
    @colorScale = d3.scale.category20()
    @sizeScaleRange = d3.scale.linear().range([ 30, 500 ])

    @transform = d3.svg.transform()
        .translate((d) -> return [ d.x , d.y ] )
        .rotate((d)-> return d.rotate)

    @debouncedUpdate = _.debounce(@update.bind(@), 1000)

    #1
  buildStage:->
    #ステージ（描画の土台）を作成
    doc = document.documentElement
    width = doc.clientWidth-20
    height = doc.clientHeight-20

    svg = d3.select("svg")
      .attr( { width: width, height: height })

    if not @stage?
      @stage = svg.append("g")

    @stage.attr("transform", d3.svg.transform().translate((d) -> return [ width >> 1 ,  height >> 1 ] ) ) #word cound は真ん中に表示する

    #レイアウトを作成
    random = d3.random.irwinHall(2)
    @layout = d3.layout.cloud()
      .size([ width, height])
      .words([{}])
      .rotate(-> Math.round(1 - random()) * 90 ) #ランダムに文字を90度回転
      .font("Impact")
      .fontSize((d) -> d.size )
      .on("end", (words) => _.defer(@draw.bind(@), words) ) #描画関数の読み込み


  start:->
    if @running
      return

    @running = true
    @buildStage()
    @update()

  stop:->
    @running = false

  update:->
    if not @running
      return

    datas = @repo.getAsArray().slice(0, @config.maxItems)
    countMax = d3.max(datas, (d) -> d.count )
    sizeScale = @sizeScaleRange.domain([ 0, countMax ])

    #頻出カウントを文字サイズに反映
    words = datas
      .map((d) ->
        text: d.word
        size: sizeScale(d.count)
      )
      .filter((v) ->  v  )

    #レイアウトに叩き込んで再計算
    @layout.words(words).start()

  draw:(words)->
    node = @stage.selectAll("text")
      .data(words, (d) ->  d.text  )  #第二引数はキー計算

    #既存のノード
    #アニメーション
    node.transition()
      .delay((d, i) => i * @config.delay)
      .duration(1000)
        .attr(  "transform", @transform )
        .style( "font-size": (d) -> d.size + "px" )
        .each("end", @debouncedUpdate.bind(@)) #ノードの数だけ呼ばれるので debounced

    #追加されたノード
    node.enter()
      .append("text")
      .style( {
          "font-family": "Impact"
          "font-size": (d) ->  d.size + "px"
          "fill": (d, i) => @colorScale(i)
      })
      .attr({
          "text-anchor": "middle"
          "transform": @transform
      } )
      .text( (d) -> d.text )

    #削除されたノード
    node.exit().remove()

    # 既存のノードが無い場合に呼ばれる
    _.delay(@debouncedUpdate.bind(@), 1000)

(exports ? this).WordCloud = WordCloud