EvMan.Views.Teams ||= {}
class EvMan.Views.Teams.Edit
  constructor: (container) ->
    @container = container

  render: ->
    @renderSelectize()

  renderSelectize: ->
    @container.find('select').selectize()