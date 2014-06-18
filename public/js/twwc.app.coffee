#メイン
#下のクラス定義に動いてほしいからdefer
_.defer ->
  config = $.extend(true,
    maxItems: 500
    wordMin: 2
    delay: 10
  , JSON.parse(window.location.hash.replace("#", "") or "{}"))

  toastr.options.positionClass = "toast-bottom-full-width"

  repo = new WordRepo(config)
  socket = new Ws()
  wc = new WordCloud(config, repo);
  rw = new Retweets();

  #a
  socket.on "tw",  (tw) ->
    rw.push tw.retweeted_status
    repo.push tw.text

  socket.on "msg", (data) ->
    toastr.warning data

  _.delay  ->
    wc.start()
    rw.start()
  ,500

#クラス定義
class Retweets
  constructor:->
    @retws = []

  start:->
    setInterval =>
      r = @retws.shift()
      if r?
        @draw(r)
    , 1000

  draw :  (r)->
    toastr.info "<img src='" + r.profile_image_url + "'>&nbsp;" + r.text + "&nbsp;[" + r.retweet_count + "]"  if r

  push : (retw)->
    @retws.push(retw)