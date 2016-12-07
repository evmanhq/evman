EvMan.Views.Talks ||= {}
class EvMan.Views.Talks.Edit
  constructor: (container) ->
    @container = container

  render: ->
    @rednerSelect2()

  rednerSelect2: ->
    @container.find('select').select2()