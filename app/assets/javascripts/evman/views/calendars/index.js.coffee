EvMan.Views.Calendars ||= {}
class EvMan.Views.Calendars.Index
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderCalendar()

  renderCalendar: ->
    $(@container).fullCalendar(
      weekNumbers: true
      firstDay: 1
      height: window.innerHeight - 110
      header:
        left: 'today prev,next'
        center: 'title'
        right: 'month,basicWeek,agendaWeek'
      windowResize: (view) ->
        $(this).fullCalendar('option', 'height', window.innerHeight - 110)
      events: (start, end, timezone, callback) ->
        $.ajax(
          url: '/events.json'
          type: 'GET'
          data:
            start: start.format('YYYY-MM-DD')
            end: end.format('YYYY-MM-DD')
          success: (data) ->
            events = []
            for event in data
              events.push(
                title: event.name,
                start: event.begins_at + "T00:00:00"
                end: event.ends_at + "T23:59:59"
                url: '/events/' + event.id
                color: event.event_type.color
              )
            callback(events)
        )
    )
