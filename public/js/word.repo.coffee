class WordRepo
  constructor: ( @config ={
    maxItems:  500
    wordMin: 2
  })->
    @segmenter = new TinySegmenter()
    @blacklist = ["HTTP","//","CO"]
    @data = {}

  getMap:->
    @data

  getAsArray:->
    _.sortBy(_.toArray(@data), (d)-> -(d.count) )

  checkReset:->
    if Object.keys(@data).length > (@config.maxItems * 10)
      @data ={}

  push : (text) ->
    @checkReset();
    @segmenter.segment(text).forEach (word)=>

      word = word.replace(/\s+/g, "").toUpperCase()

      #ブラックリストにある
      if @blacklist.indexOf(word) != -1
        return

      #2文字より少ない
      if word?.length < @config.wordMin
        return

      #集計
      if not @data[word]?
        @data[word] = {
          word : word
          count :1
        }
      else
        @data[word].count++

(exports ? this).WordRepo = WordRepo