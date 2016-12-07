var callbacks = {};

var registerCallback = function(controller, action, callback){
    if(callbacks[controller] == null) callbacks[controller] = {};
    if(callbacks[controller][action] == null) callbacks[controller][action] = [];
    callbacks[controller][action].push(callback);
};

$(document).on('turbolinks:load', function(){
    var body = $('body');

    var controller = body.data('controller');
    var action = body.data('action');

    if(callbacks[controller] != null && callbacks[controller][action] != null) {
        $.each(callbacks[controller][action], function(index, callback) {
            callback();
        });
    }
});

registerCallback('calendars', 'index', function(){
    $('#calendar').fullCalendar({
        weekNumbers: true,
        firstDay: 1,
        height: window.innerHeight - 110,
        header: {
            left: 'today prev,next',
            center: 'title',
            right: 'month,basicWeek,agendaWeek'
        },
        windowResize: function(view) {
            $(this).fullCalendar('option', 'height', window.innerHeight - 110);
        },
        events: function(start, end, timezone, callback) {
            $.ajax({
                url: '/events.json',
                type: 'GET',
                data: {
                    start: start.format('YYYY-MM-DD'),
                    end: end.format('YYYY-MM-DD')
                },
                success: function (data) {
                    var events = [];
                    for (id in data) {
                        var item = data[id];
                        events.push({
                            title: item.name,
                            start: item.begins_at + "T00:00:00",
                            end: item.ends_at + "T23:59:59",
                            url: '/events/' + item.id
                        });
                    }
                    callback(events);
                }
            });
        }
    });
});