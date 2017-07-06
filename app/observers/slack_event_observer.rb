class SlackEventObserver < Observer

  observe Event

  REJECTS = ['updated_at']

  def after_update(event)
    changes = event.changes.keys.reject { |k| REJECTS.include?(k) }
    if changes.length > 0
      changes = changes.map { |k| Event.human_attribute_name(k) }.join(',')

      mentions = [event.owner.slack_id(event.team)]
      mentions += event.attendees.all.map {|attendee| attendee.user.slack_id(event.team) }
      mentions = mentions.reject { |mention| mention == nil }.uniq.map { |member| "<@#{member}>"}.join(', ')

      Slack.post("Event <#{ENV['EVMAN_SCHEME']}://#{event.team.subdomain}.#{ENV['EVMAN_DOMAIN']}/events/#{event.id}|#{event.name}> was updated (#{changes}) /cc #{mentions}.", event.team)
    end
  end

  def after_create(event)
    Slack.post("New event <#{ENV['EVMAN_SCHEME']}://#{event.team.subdomain}.#{ENV['EVMAN_DOMAIN']}/events/#{event.id}|#{event.name}> was created.", event.team)
  end

end