ActivatePepeModeView = require './activate-pepe-mode-view'
{CompositeDisposable} = require 'atom'
configSchema = require "./config-schema"
path = require "path"

module.exports = ActivatePepeMode =
  activatePepeModeView: null
  modalPanel: null
  subscriptions: null
  config: configSchema

  activate: (state) ->
    @activatePepeModeView = new ActivatePepeModeView(state.activatePepeModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @activatePepeModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'activate-pepe-mode:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @activatePepeModeView.destroy()

  serialize: ->
    activatePepeModeViewState: @activatePepeModeView.serialize()

  toggle: ->

    if @modalPanel.isVisible()
      # Hide the meme magic panel
      @modalPanel.hide()
    else
    # Show the meme magic panel
      @modalPanel.show()

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

    if elem.style.background != ''
      # Hide pepe
      elem.style.background = ''
    else
      # Show pepe
      elem.style.background = "url(#{pepePath}) no-repeat center"
      elem.style.background.opacity = 0.1
