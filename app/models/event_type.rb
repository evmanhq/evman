class EventType < ApplicationRecord

  belongs_to  :team
  has_many :events

  validates :name, presence: true
  validates :color, length: { is: 7 }

  def color
    ret = super
    return '#3a87ad' if ret.blank?
    ret
  end

end
