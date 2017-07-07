EvMan.Views.Talks ||= {}
class EvMan.Views.Talks.Index
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderTalkSearch()

  renderTalkSearch: ->
    @container.find('#search_for_talk').keypress (event) =>
      clearTimeout(@searchForTalksTimeout)
      if event.which == 13
        @talkSearch()
      else
        @searchForTalksTimeout = setTimeout(@talkSearch, 1000)

  talkSearch: =>
    q = @container.find('#search_for_talk').val()
    $.get '/talks.json', {'q': {'term': q}}, (talks) =>
      target = @container.find('#search_for_talk_results')
      target.empty();

      list = $('<ul/>').addClass('list-group list-group-flush')
      target.append(list)

      if talks.length == 0
        b = $('<b/>').html(q)
        li = $('<li/>').addClass('list-group-item').html('No talks founds for ')
        li.append(b)
        target.append(li)
        return

      $(talks).each (i, talk) ->
        a = $('<a/>').attr('href', '/talks/' + talk.id).html(talk.name)
        li = $('<li/>').addClass('list-group-item').html(a)
        list.append(li)