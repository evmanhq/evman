EvMan.Views.EventProperties ||= {}
class EvMan.Views.EventProperties.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderBehaviourSelect()

  renderBehaviourSelect: ->
    @container.find('#event_property_behaviour').selectize()