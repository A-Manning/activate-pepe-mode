{CompositeDisposable} = require 'atom'
configSchema = require './config-schema'
path = require 'path'
fs = require 'fs'

module.exports = ActivatePepeMode =
  subscriptions: null
  active: false
  config: configSchema
  frogPath: path.join(__dirname, '../pepes/').replace(/\\/g, '/')
  frogArray: []
  frog_loop: null
  current_frog: null

  loadfolder: (frogPath) ->
    @frogArray = fs.readdirSync frogPath

  randomfrog: (frogArray) ->
    @numfrogs = frogArray.length
    if @numfrogs != 0
      @randomnum = Math.floor (Math.random() * @numfrogs)
      @current_frog = frogArray[@randomnum]
    else console.log "REEEEEE no frogs"

  setbackground: (imagePath) ->
    # TODO: Delete
    elem = document.getElementsByTagName('atom-text-editor')[0]
    @editor = atom.workspace.getActiveTextEditor()

    if not @editor
      return

    editorElement = atom.views.getView @editor

    frogimg = document.getElementById('frog-img')
    frogimg?.parentNode.removeChild(frogimg)
    if imagePath != ''

      image = document.createElement('img')
      image.setAttribute('id', 'frog-img')
      image.setAttribute('class', 'frog-img')
      image.setAttribute('src', imagePath)

      editorElement.appendChild(image)

  setrandomfrog: ->
    @randomfrog(@frogArray)
    @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
     "activate-pepe-mode:toggle": => @toggle()
     "activate-pepe-mode:enable":  => @enable()
     "activate-pepe-mode:disable": => @disable()
    @changePaneSubscription = atom.workspace.onDidStopChangingActivePaneItem =>
      console.log "changed pane"
      @subscribeToActiveTextEditor()

  subscribeToActiveTextEditor: ->
    console.log "changed editor"
    @enable()
    #@setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')

  deactivate: ->
    @subscriptions?.dispose()
    @active = false

  toggle: ->
    #console.log @frogPath
    if @active then @disable() else @enable()

  enable: ->
    @active = true
    @changePaneSubscription = atom.workspace.onDidStopChangingActivePaneItem =>
      @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')
      @change_frog_loop()
    console.log "ACTIVATE PEPE MODE!!"

    # set frogPath
    if (atom.config.get 'activate-pepe-mode.frogPath') != ''
      @frogPath = atom.config.get 'activate-pepe-mode.frogPath'
    # initialise
    @loadfolder @frogPath
    @randomfrog(@frogArray)
    @setbackground path.join(@frogPath, @current_frog).replace(/\\/g, '/')
    @change_frog_loop()

  change_frog_loop: ->
    if not @active
      clearInterval(change_frog_loop)

    callback = => @setrandomfrog()
    @frog_loop = setInterval(callback, atom.config.get 'activate-pepe-mode.timing')

  disable: ->
    @active = false
    clearInterval(@frog_loop)
    @setbackground ''
    console.log 'feelsbadman.jpg'
