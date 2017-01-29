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
  pepe_loop: null
  elem: document.getElementsByTagName('atom-text-editor')[0]

  loadfolder: (pepePath2) ->
    @pepeArray = fs.readdirSync pepePath2

  randompepe: (pepeArray) ->
    @numpepes = pepeArray.length
    if @numpepes != 0
      @randomnum = Math.floor (Math.random() * @numpepes)
      pepeArray[@randomnum]
    else console.log "REEEEEE no pepes"

  setbackground: (imagePath) ->
    # TODO: Delete

    pepeimg = document.getElementById('pepe-img')
    pepeimg?.parentNode.removeChild(pepeimg)
    if imagePath != ''

      image = document.createElement('img')
      image.setAttribute('id', 'pepe-img')
      image.setAttribute('class', 'pepe-img')
      image.setAttribute('src', imagePath)
      @elem.appendChild(image)

  setrandompepe: ->
    console.log "loops"
    nextpepe = @randompepe(@pepeArray)
    @setbackground path.join(@pepePath2, nextpepe).replace(/\\/g, '/')

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
    console.log @active
    if @active then @disable() else @enable()
    #console.log @active

  enable: ->
    @active = true
    console.log "ACTIVATE PEPE MODE"
    @loadfolder @pepePath2
    nextpepe = path.join(@pepePath2, @randompepe(@pepeArray)).replace(/\\/g, '/')
    @setbackground nextpepe
    @setrandompepe()
    @change_pepe_loop()

  change_pepe_loop: ->
    if not @active
      console.log "not active"
      clearInterval(change_pepe_loop)

    callback = => @setrandompepe()
    @pepe_loop = setInterval(callback, 1000)

  disable: ->
    @active = false
    clearInterval(@pepe_loop)
    @setbackground ''
    console.log 'feelsbadman.jpg'
