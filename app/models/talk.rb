class Talk < ApplicationRecord

  belongs_to  :team
  belongs_to  :user
  belongs_to  :event_type

  has_many :event_talks, dependent: :destroy
  has_many :events, :through => :event_talks

  has_many  :taggeds, :as => :item, dependent: :destroy, inverse_of: :item
  has_many  :tags, -> { distinct }, :through => :taggeds

  validates :name, presence: true
  validates :event_type, presence: true
  validates :user, presence: true
  validates :team, presence: true

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  authorize_values_for :user
  authorize_values_for :event_type
end
