{CompositeDisposable} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = ActivatePepeMode =
  config: configSchema
  subscriptions: null
  active: false
  pepePath: atom.config.get 'activate-pepe-mode.pepePath'
  pepePath2: path.join(__dirname, '../pepes/').replace(/\\/g, '/')
  pepeArray: []
  background: null
  nextpepe: ""

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
     "activate-pepe-mode:toggle": => @toggle()
     "activate-pepe-mode:enable":  => @enable()
     "activate-pepe-mode:disable": => @disable()



  deactivate: ->
    @subscriptions?.dispose()
    @active = false

  toggle: ->
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    console.log "ACTIVATE PEPE MODE"
    @setpath()
    @loadfolder @pepePath2
    @nextpepe = path.join(@pepePath2, @randompepe()).replace(/\\/g, '/')
    @setbackground @nextpepe
    @nextpepe = path.join(@pepePath2, @randompepe()).replace(/\\/g, '/')
    @slide()

  slide: ->
    setTimeout @setbackground, 1000, @nextpepe

  disable: ->
    @active = false
    @setbackground ''
    console.log 'feelsbadman.jpg'

  setpath: ->
    if @pepePath == undefined
      @pepePath = path.join(__dirname, '../pepes/EVJfi7d.png').replace(/\\/g, '/')
    #console.log "pepe path set to #{@pepePath}"


  setbackground: (imagePath) ->
    # TODO: Delete
    wall = 'atom-text-editor'
    elem = document.getElementsByTagName(wall)[0]

    if imagePath == ''
      pepediv = document.getElementById('pepediv')
      pepediv.parentNode.removeChild(pepediv)
      #console.log "REEEEEEEEE couldn't find image"
    else
      pepeimg = document.getElementById("pepediv")
      if pepeimg?
        pepeimg.parentNode.removeChild(pepeimg)

      pepediv = document.createElement('div')
      pepediv.setAttribute('id','pepediv')
      pepediv.setAttribute('style', 'position: absolute; top: 0; right: 0; left: 0; bottom: 0; margin:auto;')
      elem.appendChild(pepediv)
      image = document.createElement('img')
      image.setAttribute('id', 'pepe-img')
      image.setAttribute('src', imagePath)
      image.setAttribute('style', "position: absolute; z-index: 100; opacity: 0.1; top: 0; right: 0; left: 0; bottom: 0; margin:auto;")
      document.getElementById('pepediv').appendChild(image)

  loadfolder: (pepePath2) ->
    @pepeArray = fs.readdirSync pepePath2

  randompepe: ->
    numpepes = @pepeArray.length
    if numpepes != 0
      randomnum = Math.floor (Math.random() * numpepes)
      randompepe = @pepeArray[randomnum]
      randompepe
    else "REEEEEE no pepes"
