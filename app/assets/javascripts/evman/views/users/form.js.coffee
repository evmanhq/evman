EvMan.Views.Users ||= {}
class EvMan.Views.Users.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @container.find('select').selectize()