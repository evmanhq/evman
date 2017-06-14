class Attendee < ApplicationRecord

  belongs_to :user
  belongs_to :event, inverse_of: :attendees
  belongs_to :attendee_type

  after_create do
    id = user.slack_id(self.event.team)
    if id
      Slack.post("<@#{id}> is attending <https://staging.evman.io/events/#{self.event.id}|#{self.event.name}>.", self.event.team)
    end
  end

  before_destroy do
    id = user.slack_id(self.event.team)
    if id
      Slack.post("<@#{id}> is no longer attending <https://staging.evman.io/events/#{self.event.id}|#{self.event.name}>.", self.event.team)
    end
  end


end
