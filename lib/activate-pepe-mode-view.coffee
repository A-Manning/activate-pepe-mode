module.exports =
class ActivatePepeModeView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('activate-pepe-mode')

    # Create message element
    message = document.createElement('div')
    message.textContent = "MEME MAGIC IS REAL"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
