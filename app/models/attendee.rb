class Attendee < ApplicationRecord

  belongs_to :user
  belongs_to :event, inverse_of: :attendees
  belongs_to :attendee_type

end
