EvMan.Views.Goals ||= {}
class EvMan.Views.Goals.Index
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderSelect2()

  renderSelect2: ->
    @container.find('select').select2()