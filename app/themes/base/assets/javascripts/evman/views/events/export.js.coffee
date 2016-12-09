EvMan.Views.Events ||= {}

class EvMan.Views.Events.Export
  constructor: (container) ->
    @container = container

  render: ->
    @renderDatePicker()
    @renderSelect2()
    @renderCitySelect2()
    @renderCountrySelect2()

  renderOnBeginsAtChange: ->
    begins_at = @container.find('#begins_at')
    begins_at.on 'change', @onBeginsAtChange

  onBeginsAtChange: =>
    begins_at = @container.find('#begins_at')
    ends_at = @container.find('#ends_at')
    ends_at.val(begins_at.val()) if ends_at.val() == ''

  renderDatePicker: ->
    @container.find('.date').datepicker({'dateFormat':'yy-mm-dd'})

  renderSelect2: ->
    @container.find('select').not('#city_id').select2()

  renderCitySelect2: ->
    @container.find('#city_id').select2({
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

  renderCountrySelect2: ->
    @container.find('#country_id').select2({
      placeholder: "Search for country"
      minimumInputLength: 1
      ajax:
        url: "/geo/countries.json"
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