class AttendeeType < ApplicationRecord

  belongs_to  :team
  has_many :attendees

end
