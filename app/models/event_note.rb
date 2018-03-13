class EventNote < ApplicationRecord

  belongs_to  :user
  belongs_to  :event

  # after_create do
  #   users = (event.event_notes.all.map { |note| note.user} + event.attendees.all.map { |attendee| attendee.user })
  #   users = users.map { |user| user.slack_id(self.event.team) }
  #   users = users.uniq.map { |member| "<@#{member}>"}.join(', ')
  #
  #   Slack.post({
  #       :text => "New note at <https://staging.evman.io/events/#{self.event.id}|#{self.event.name}> /cc #{users}.",
  #       :attachments => [{ :title => '', :text => self.content }]
  #              }, self.event.team)
  # end

  def concerned_teams
    event.concerned_teams
  end

  def concerned_users
    (event.concerned_users + event.event_notes.map { |note| note.user } + [user]).uniq
  end

end
