EvMan.Views.Roles ||= {}
class EvMan.Views.Roles.EditUser
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderSelectize()

  renderSelectize: ->
    @container.find('.selectize').selectize(plugins: ['remove_button'])