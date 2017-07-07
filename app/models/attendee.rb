class Attendee < ApplicationRecord

  belongs_to :user
  belongs_to :event, inverse_of: :attendees
  belongs_to :attendee_type

  def concerned_teams
    event.concerned_teams
  end

  def concerned_users
    event.concerned_users
  end

end
