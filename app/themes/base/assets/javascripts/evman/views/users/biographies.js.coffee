EvMan.Views.Users ||= {}
class EvMan.Views.Users.Biographies
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @activateFirstTab()

  activateFirstTab: ->
    bio_link = @container.find('.nav-tabs .default-biography')
    bio_link.tab('show')