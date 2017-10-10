EvMan.Views.Calendars ||= {}
class EvMan.Views.Calendars.Index
  constructor: (container, options) ->
    @container = container
    @options = options

    @calendar_div = @container.find('#calendar')
    @filter_form = @container.find('form#filter')

  render: =>
    @renderCalendar()

    @filter_form.submit(@handleFilter)

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
        params = @filter_form.serializeArray()
        params.push({name: "start", value: start.format('YYYY-MM-DD') })
        params.push({name: "end", value: end.format('YYYY-MM-DD') })

        $.ajax(
          url: '/calendars/events.json'
          type: 'GET'
          data: $.param(params)
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

  handleFilter: (event) =>
    event.preventDefault()
    event.stopPropagation()

    @calendar_div.fullCalendar('refetchEvents')
