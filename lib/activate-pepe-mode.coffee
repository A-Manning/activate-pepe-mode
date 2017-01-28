ActivatePepeModeView = require './activate-pepe-mode-view'
{CompositeDisposable} = require 'atom'
configSchema = require "./config-schema"
path = require "path"

module.exports = ActivatePepeMode =
  config: configSchema
  subscriptions: null
  active: false

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

    # Get the editor
    wall = 'atom-text-editor'
    #console.log wall

    # Get list of editor properties
    elem = document.getElementsByTagName(wall)[0]
    #console.log elem
    #console.log elem.style.color
    console.log path

    pepePath = atom.config.get "activate-pepe-mode.pepePath"
    console.log "user pepePath is #{pepePath}"
    if pepePath == ""
      pepePath = path.join(__dirname, '../pepes/EVJfi7d.png')
    console.log "pepePath set to #{pepePath}"
    # build the background image

    pepe = new Image(pepePath)
    console.log "pepe is"
    console.log pepe

    pepePath = pepePath.replace(/\\/g, '/');

    console.log "new #{pepePath}"

    if elem.style.background != ''
      # Hide pepe
      elem.style.background = ''
    else
      # Show pepe
      elem.style.background = "url(#{pepePath}) no-repeat center"
      elem.style.background.opacity = 0.1

  enable: ->
    @active = true

  disable: ->
    @active = false
    console.log "meme magic is real"
