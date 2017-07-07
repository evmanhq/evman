EvMan.Views.Tasks ||= {}
class EvMan.Views.Tasks.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderDatePicker()

  renderDatePicker: ->
    @container.find('.date').datepicker dateFormat: 'yy-mm-dd'