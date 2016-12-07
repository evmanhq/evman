class EvMan.Views.Filterer
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @filterer = new EvMan.Components.Filterer(@options.filter_templates, @options.filters, {
      container: @container,
      url: @options.url
    })
    @filterer.render();