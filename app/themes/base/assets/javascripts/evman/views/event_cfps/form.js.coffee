EvMan.Views.EventTalks ||= {}
class EvMan.Views.EventTalks.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderUserSelect2()
    @renderTalkSelect2()
    @renderEventSelect2()

  renderUserSelect2: ->
    @container.find('#event_talk_user_id').select2()

  renderTalkSelect2: ->
    @container.find('#event_talk_talk_id').select2
      placeholder: "Search for talk"
      minimumInputLength: 1
      ajax:
        url: @options.talks_path
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        processResults: (data, page) -> { results: data }
      templateResult: (item) ->
        if item.name then item.name else item.text
      templateSelection: (item) ->
        if item.name then item.name else item.text
      id: (item) -> item.id

  renderEventSelect2: ->
    @container.find('#event_talk_event_id').select2
      placeholder: "Search for event"
      minimumInputLength: 1
      ajax:
        url: @options.events_path
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        processResults: (data, page) -> { results: data }
      templateResult: (item) ->
        if item.name then item.name + ' (' + item.begins_at + ')' else item.text
      templateSelection: (item) ->
        if item.name then item.name + ' (' + item.begins_at + ')' else item.text
      id: (item) -> item.id
