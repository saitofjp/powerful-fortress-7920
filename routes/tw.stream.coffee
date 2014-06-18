exports.bind = (app, io) ->
  
  # add start
  util = require("util")
  twitter = require("twitter")

  twit = new twitter(
    consumer_key: process.env.TWITTER_CONSUMER_KEY
    consumer_secret: process.env.TWITTER_CONSUMER_SECRET
    access_token_key: process.env.TWITTER_ACCESS_TOKEN_KEY
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
  )
  full = false
  
  # Twitter Streaming APIを呼び出す
  twit.stream "statuses/filter", {  track: "PS4" } , (stream) ->
    stream.on "data", (data) ->

      rts = data.retweeted_status

      retweeted_status = (if not rts then null else
        id_str: rts.id_str
        text: rts.text
        lang: rts.lang
        retweet_count: rts.retweet_count
        profile_image_url: rts.user.profile_image_url
        created_at: rts.created_at
      )

      io.sockets.emit "tw", {
        id_str: data.id_str
        text: data.text
        lang: data.lang
        created_at: data.created_at
        retweeted_status: retweeted_status
        profile_image_url: data.user.profile_image_url
      }

      io.sockets.emit "twfull", data  if full

  app.get "/ws/tw/full/:flg", (req, res) ->
    full = (req.params.flg is "on")
    res.send()

  app.get "/ws/:cmd/:message", (req, res) ->
    io.sockets.emit req.params.cmd, req.params.message
    res.send req.params.cmd + "/" + req.params.message
