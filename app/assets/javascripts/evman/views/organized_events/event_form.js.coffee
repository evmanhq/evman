EvMan.Views.OrganizedEvents ||= {}
class EvMan.Views.OrganizedEvents.EventForm
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderLanguagesSelect()
    @renderTshirtSizesSelect()
    @renderDifficultiesSelect()
    @renderPaperTypesSelect()
    @renderTracksSelect()
    @renderOwnerSelect()

  renderLanguagesSelect: ->
    select = @container.find('#organized_event_language_ids')
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'id'
      labelField: 'text'
      preload: true
      persist: false
      load: (query, callback) ->
        $.ajax
          url: '/languages.json'
          data:
            q: query
          type: 'GET'
          error: () -> callback()
          success: (res) -> callback(res)

  renderTshirtSizesSelect: ->
    select = @container.find('#organized_event_organized_event_tshirt_size_ids')
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'id'
      labelField: 'text'
      preload: true
      persist: true
      create: (input, callback) ->
        $.ajax
          url: '/organized_event_tshirt_sizes'
          type: 'POST'
          data:
            name: input
          error: -> callback()
          success: (res) -> callback(res)
        undefined # asynchronous create callback has to return undefined

      load: (query, callback) ->
        $.ajax
          url: '/organized_event_tshirt_sizes.json'
          data:
            q: query
          type: 'GET'
          error: () -> callback()
          success: (res) -> callback(res)

  renderDifficultiesSelect: ->
    select = @container.find('#organized_event_organized_event_difficulty_ids')
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'id'
      labelField: 'text'
      preload: true
      persist: true
      create: (input, callback) ->
        $.ajax
          url: '/organized_event_difficulties'
          type: 'POST'
          data:
            name: input
          error: -> callback()
          success: (res) -> callback(res)
        undefined # asynchronous create callback has to return undefined

      load: (query, callback) ->
        $.ajax
          url: '/organized_event_difficulties.json'
          data:
            q: query
          type: 'GET'
          error: () -> callback()
          success: (res) -> callback(res)

  renderPaperTypesSelect: ->
    select = @container.find('#organized_event_organized_event_paper_type_ids')
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'id'
      labelField: 'text'
      preload: true
      persist: true
      create: (input, callback) ->
        $.ajax
          url: '/organized_event_paper_types'
          type: 'POST'
          data:
            name: input
          error: -> callback()
          success: (res) -> callback(res)
        undefined # asynchronous create callback has to return undefined

      load: (query, callback) ->
        $.ajax
          url: '/organized_event_paper_types.json'
          data:
            q: query
          type: 'GET'
          error: () -> callback()
          success: (res) -> callback(res)

  renderTracksSelect: ->
    select = @container.find('#organized_event_track_names')
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'text'
      labelField: 'text'
      preload: true
      persist: true
      create: (input) -> { text: input }
  renderOwnerSelect: ->
    select = @container.find('#organized_event_owner_id')
    select.selectize()