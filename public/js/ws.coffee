 class Ws
  constructor: ( noConnect )->
    @host = window.location.hostname
    @timeReconnect = 2000
    if not noConnect
      @connect()

  connect :->
    @onopen = false;
    @socket = io.connect @host
    @autoReconect()

    @socket.on 'connect',  =>
      @onopen = true

  on : (key, func)->
    @socket.on key ,func

  emit : (key, data)->
    if @onopen
      @socket.emit key ,data

  autoReconect:->
    setInterval =>
      if @socket.socket.connected == false && @socket.socket.connecting == false
        @socket.socket.connect()

    , @timeReconnect

 (exports ? this).Ws =  Ws