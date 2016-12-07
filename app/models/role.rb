class Role < ApplicationRecord
  belongs_to :team
  has_and_belongs_to_many :users

  serialize :authorization_profile, Authorization::Profile

  validates :name, presence: true
  validates :default, uniqueness: { scope: [:team_id], allow_blank: true }

  def can? *args
    authorization_profile.authorized? *args
  end
end
