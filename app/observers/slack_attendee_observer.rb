class SlackAttendeeObserver < Observer

  observe Attendee

  def after_create(attendee)
    # id = attendee.user.slack_id(attendee.event.team)
    # if id
    #   Slack.post("<@#{id}> is attending <https://staging.evman.io/events/#{attendee.event.id}|#{attendee.event.name}>.", attendee.event.team)
    # end
  end

  def after_destroy(attendee)
    # id = attendee.user.slack_id(attendee.event.team)
    # if id
    #   Slack.post("<@#{id}> is no longer attending <https://staging.evman.io/events/#{attendee.event.id}|#{attendee.event.name}>.", attendee.event.team)
    # end
  end

end