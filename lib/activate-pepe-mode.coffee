ActivatePepeModeView = require './activate-pepe-mode-view'
{CompositeDisposable} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = ActivatePepeMode =
  config: configSchema
  subscriptions: null
  active: false
  pepePath: atom.config.get 'activate-pepe-mode.pepePath'
  pepePath2: path.join(__dirname, '../pepes/')
  pepeArray: []
  background: null

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
    nextpepe = path.join(@pepePath2, @randompepe())
    @setbackground nextpepe

  disable: ->
    @active = false
    @setbackground ''
    console.log 'feelsbadman.jpg'

  setpath: ->
    if @pepePath == undefined
      @pepePath = path.join(__dirname, '../pepes/EVJfi7d.png')
      @pepePath = @pepePath.replace(/\\/g, '/')
    #console.log "pepe path set to #{@pepePath}"

  setbackground: (imagePath) ->
    wall = 'atom-text-editor'
    elem = document.getElementsByTagName(wall)[0]
    if imagePath == ''
      elem.style.background = ''
      #console.log "REEEEEEEEE couldn't find image"
    else
      elem.style.background = "url(#{imagePath}) no-repeat center"


  loadfolder: (pepePath2) ->
    @pepeArray = fs.readdirSync pepePath2

  randompepe: ->
    numpepes = @pepeArray.length
    if numpepes != 0
      randomnum = Math.floor (Math.random() * numpepes)
      randompepe = @pepeArray[randomnum]
      randompepe
    else "REEEEEE no pepes"
