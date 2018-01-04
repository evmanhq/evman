EvMan.Views.FilterBookmarks ||= {}
class EvMan.Views.FilterBookmarks.Form
  constructor: (container) ->
    @container = container

  render: ->
    @rednerSelect2()

  rednerSelect2: ->
    @container.find('select').select2()