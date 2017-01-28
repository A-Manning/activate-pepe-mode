module.exports =

  setup: (editorElement) ->
    @container = @createElement "pepe-canvas"
    (editorElement.shadowRoot ? editorElement).querySelector(".scroll-view").appendChild @container
