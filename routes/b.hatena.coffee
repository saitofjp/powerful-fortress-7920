exports.bind = (app) ->

  hatenaB = new HatenaB();

  app.get "/b.hatena/:keyword.json", (req, res) ->
    console.log "keyword " + req.params.keyword

    hatenaB.request req.params.keyword, (error, xml) ->
      hatenaB.toJsonArray xml, (error, data) ->
        res.send data

  app.get "/b.hatena/:keyword.xml", (req, res) ->
    console.log "keyword " + req.params.keyword

    hatenaB.request req.params.keyword, (error, xml) ->
      res.send xml


request = require("request")
querystring = require("querystring")
to_json = require("xmljson").to_json

class HatenaB

  request : (keyword, callback) ->
    api = "http://b.hatena.ne.jp/search/tag?" + querystring.stringify(
      users: 3
      sort: "recent"
      mode: "rss"
      q: keyword
    )
    request api, (error, response, body) ->
      console.log "remeote " + api + " " + response.statusCode
      if not error and response.statusCode is 200
        callback null, body
      else
        callback error or response.statusCode, {}

  toJsonArray : (xml, callback) ->
    to_json xml, (error, data) ->
      if error
        callback error, data
      else
        res = []
        items = data["rdf:RDF"].item
        for i of items
          res.push items[i]
        callback null, res
