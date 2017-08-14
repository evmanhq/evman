EvMan.Views.EventPropertyOptions ||= {}
class EvMan.Views.EventPropertyOptions.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderParentSelect()

  renderParentSelect: ->
    @container.find('#event_property_option_parent_id').selectize()