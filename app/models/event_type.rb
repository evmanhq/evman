class EventType < ApplicationRecord

  belongs_to  :team
  has_many :events

end
