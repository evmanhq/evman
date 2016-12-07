EvMan.Views.Events ||= {}
class EvMan.Views.Events.Show
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderMap()

  renderMap: ->
    L.mapbox.accessToken = window.mapbox;
    map = L.mapbox.map('map', 'mapbox.streets').setView([40, -74.50], 9)
    params = {q: @options.event_full_location, format: 'json'}

    $.get 'https://nominatim.openstreetmap.org/search', params, (data) ->
      if (data.length > 0)
        map.setView([data[0].lat, data[0].lon], 13)

    $('.map-trigger').click ->
      $('.map-modal').modal().on 'shown.bs.modal', ->
        map.invalidateSize()