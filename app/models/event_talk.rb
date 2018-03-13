class EventTalk < ApplicationRecord

  belongs_to  :talk
  belongs_to  :user
  belongs_to  :event

  validates_presence_of :talk, :user, :event
  validates :event_id, uniqueness: { scope: [:talk_id, :user_id, :event_id] }

  # after_update do
  #   if self.changes.keys.include?('state')
  #     change = case self.state
  #       when true
  #         ' was accepted '
  #       when false
  #         ' was rejected '
  #       when nil
  #         ' is not yet decided '
  #       end
  #     team = self.event.team
  #     Slack.post("#{self.user.name}'s talk <https://#{team.name}.evman.io/event_talks/#{self.id}|#{self.talk.name}> #{change} for <https://#{team.name}.evman.io/event_talks/#{self.event.id}|#{self.event.name}>.", self.event.team)
  #   end
  # end

  def concerned_teams
    event.concerned_teams
  end

  def concerned_users
    (event.concerned_users + [user]).uniq
  end

end
