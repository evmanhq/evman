class Contact < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :events
end
