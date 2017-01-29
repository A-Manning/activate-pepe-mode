{CompositeDisposable} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = ActivatePepeMode =
  subscriptions: null
  active: false
  pepePath: path.join(__dirname, '../pepes/').replace(/\\/g, '/')
  pepeArray: []
  pepe_loop: null
  current_pepe:null

  loadfolder: (pepePath) ->
    @pepeArray = fs.readdirSync pepePath

  randompepe: (pepeArray) ->
    @numpepes = pepeArray.length
    if @numpepes != 0
      @randomnum = Math.floor (Math.random() * @numpepes)
      @current_pepe = pepeArray[@randomnum]
    else console.log "REEEEEE no pepes"

  setbackground: (imagePath) ->
    # TODO: Delete
    elem = document.getElementsByTagName('atom-text-editor')[0]
    editor = atom.workspace.getActiveTextEditor()
    editorElement = atom.views.getView editor

    pepeimg = document.getElementById('pepe-img')
    pepeimg?.parentNode.removeChild(pepeimg)
    if imagePath != ''

      image = document.createElement('img')
      image.setAttribute('id', 'pepe-img')
      image.setAttribute('class', 'pepe-img')
      image.setAttribute('src', imagePath)
      editorElement.appendChild(image)

  setrandompepe: ->
    #console.log "loops"
    @randompepe(@pepeArray)
    @setbackground path.join(@pepePath, @current_pepe).replace(/\\/g, '/')

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
     "activate-pepe-mode:toggle": => @toggle()
     "activate-pepe-mode:enable":  => @enable()
     "activate-pepe-mode:disable": => @disable()
    @activeItemSubscription = atom.workspace.onDidStopChangingActivePaneItem =>
      @subscribeToActiveTextEditor()

  subscribeToActiveTextEditor: ->
    console.log "changed editor"
    @setbackground path.join(@pepePath, @current_pepe).replace(/\\/g, '/')

  deactivate: ->
    @subscriptions?.dispose()
    @active = false

  toggle: ->
    #console.log @pepePath
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    console.log "ACTIVATE PEPE MODE"
    @loadfolder @pepePath
    @randompepe(@pepeArray)
    #console.log @pepePath
    #console.log @current_pepe
    @setbackground path.join(@pepePath, @current_pepe).replace(/\\/g, '/')
    @setrandompepe()
    @change_pepe_loop()

  change_pepe_loop: ->
    if not @active
      console.log "not active"
      clearInterval(change_pepe_loop)

    callback = => @setrandompepe()
    @pepe_loop = setInterval(callback, 15000)

  disable: ->
    @active = false
    clearInterval(@pepe_loop)
    @setbackground ''
    console.log 'feelsbadman.jpg'
