EvMan.Views.Events ||= {}


class EvMan.Views.Events.Export
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @container.on 'submit', => setTimeout(@enableSubmit, 1000)

  enableSubmit: =>
    @container.find('input[type=submit]').prop('disabled', false)
