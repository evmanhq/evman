EvMan.Views.PerformanceMetricEntries ||= {}
class EvMan.Views.PerformanceMetricEntries.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderSelect2()

  renderSelect2: ->
    @container.find('select').select2()