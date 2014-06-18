exports.bind = (app, io) ->
  #Routerを使った方式に変更したい
  require("./b.hatena").bind app, io
  require("./tw.stream").bind app, io
  require("./pdf").bind app, io
