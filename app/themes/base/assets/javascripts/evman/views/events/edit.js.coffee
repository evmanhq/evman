EvMan.Views.Events ||= {}
class EvMan.Views.Events.Edit
  constructor: (container) ->
    @container = container

  render: ->
    @renderDatePicker()
    @rednerSelect2()
    @renderEventCitySelect2()
    @renderOnBeginsAtChange()

  renderOnBeginsAtChange: ->
    begins_at = @container.find('#event_begins_at')
    begins_at.on 'change', @onBeginsAtChange

  onBeginsAtChange: =>
    begins_at = @container.find('#event_begins_at')
    ends_at = @container.find('#event_ends_at')
    ends_at.val(begins_at.val()) if ends_at.val() == ''

  renderDatePicker: ->
    @container.find('.date').datepicker({'dateFormat':'yy-mm-dd'})

  rednerSelect2: ->
    @container.find('select').not('#event_city_id').select2()

  renderEventCitySelect2: ->
    @container.find('#event_city_id').select2({
      placeholder: "Search for city"
      minimumInputLength: 1
      ajax:
        url: "/geo/cities.json"
        dataType: 'json'
        quietMillis: 250
        data: (term, page) ->
          {q: term}
        processResults: (data, page) ->
          {results: data}
      templateResult: (item) ->
        if item.name then item.name else item.text
      templateSelection: (item) ->
        if item.name then item.name else item.text
      id: (item) ->
        item.id
    })