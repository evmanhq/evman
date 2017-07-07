class EvMan.Views.RequireModal
  constructor: (link, options) ->
    @link = link
    @options = options

  render: ->
    @link.click()