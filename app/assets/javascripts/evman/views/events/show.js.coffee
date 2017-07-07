EvMan.Views.Events ||= {}
class EvMan.Views.Events.Show
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderMap()

  renderMap: ->
    map = L.map('map').setView([40, -74.50], 9)

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map)

    params = {q: @options.event_full_location, format: 'json'}

    $.get 'https://nominatim.openstreetmap.org/search', params, (data) ->
      if (data.length > 0)
        map.setView([data[0].lat, data[0].lon], 13)

    $('.map-trigger').click ->
      $('.map-modal').modal().on 'shown.bs.modal', ->
        map.invalidateSize()