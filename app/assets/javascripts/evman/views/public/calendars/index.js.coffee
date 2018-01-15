EvMan.Views.Public ||= {}
EvMan.Views.Public.Calendars ||= {}
class EvMan.Views.Public.Calendars.Index
  constructor: (container, options) ->
    @container = container
    @options = options

    @calendar_div = @container.find('#calendar')

  render: =>
    @renderCalendar()

  renderCalendar: =>
    @calendar_div.fullCalendar(
      weekNumbers: true
      firstDay: 1
      height: window.innerHeight - 320
      header:
        left: 'today prev,next'
        center: 'title'
        right: 'month,basicWeek,agendaWeek'
      windowResize: (view) ->
        $(this).fullCalendar('option', 'height', window.innerHeight - 110)
      events: (start, end, timezone, callback) =>
        params = {
          start: start.format('YYYY-MM-DD'),
          end: end.format('YYYY-MM-DD'),
          filter_bookmark_code: @options.filter_bookmark_code
        }

        $.ajax(
          url: '/public/calendars/events.json'
          type: 'GET'
          data: params
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

