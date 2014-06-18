exports.bind = (app, io) ->

  fs = require("fs")
  pdf = new Pdf()

  app.get "/pdf", (req, res) ->
    if not req.query?.p?
      res.send("/pdf?p={url}")
      return

    console.log(req.query.p)
    pdf.create req.query.p, (err, pdffile) ->
      if err then res.send("error")

      res.download pdffile, "download.pdf", ()  =>
        fs.unlinkSync pdffile



phantom = require("node-phantom")
#PDF作成
class Pdf
  constructor:->
    @phantomPath = process.env.PHANTOMJS || require("phantomjs").path
    console.log @phantomPath
    @config = {
      phantomPath: @phantomPath
    }
    @tempbase = "output/"


  create:(url, callback)->
    onCreate = (err, ph) =>
      callback(err)  if err
      console.log "create"

      ph.createPage (err, page) =>
        callback(err)  if err
        console.log "createPage"

        @open page, url, (err, data) =>
          callback(err, data)
          ph.exit ->
            console.log "exit"

    phantom.create onCreate,  @config

  open : (page, url , callback) ->
    console.log url;

    page.set('viewportSize', { width: 1280, height: 780 });
    page.set "paperSize",
      format: "A4"
      orientation: "portrait"
      margin:
        left: "2.5cm"
        right: "2.5cm"
        top: "1cm"
        bottom: "1cm"

    page.open url, (err, status) =>
      console.log "page opend"

      pdffile = @tempbase + Date.now() + ".pdf"
      setTimeout =>
        page.render pdffile
        page.close => callback(err, pdffile )
      ,500


