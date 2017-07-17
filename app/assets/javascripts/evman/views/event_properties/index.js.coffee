EvMan.Views.EventProperties ||= {}
class EvMan.Views.EventProperties.Index
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @container.sortable({
      handle: '.sort-handle',
      stop: @saveSort,
    })

  saveSort: =>
    $.ajax
      url: @options.sort_path
      data:
        sorted_ids: @container.sortable('toArray')
      type: 'PUT'