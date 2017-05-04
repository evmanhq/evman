class Team < ApplicationRecord

  has_many  :team_memberships, dependent: :delete_all
  has_many  :users, :through => :team_memberships
  has_many  :roles, dependent: :destroy
  has_one   :default_role, -> { where(default: true) }, class_name: 'Role'

  has_many  :events, inverse_of: :team

  has_many  :event_types
  has_many  :attendee_types
  has_many  :expense_types

  has_many  :talks
  has_many :event_talks, :through => :events

  has_many  :tags

  has_many  :team_invitations
  has_many :forms

  has_one   :slack_setting
  has_and_belongs_to_many :warehouses

  validates :subdomain, uniqueness: true

  after_create :self_check
  before_validation :set_subdomain

  def self_check
    EventType.find_or_create_by(:name => 'Conference', :team => self, :default => true)
    EventType.find_or_create_by(:name => 'User group', :team => self)

    AttendeeType.find_or_create_by(:name => 'Lead', :team => self, :default => true)
    AttendeeType.find_or_create_by(:name => 'Supporter', :team => self)

    ExpenseType.find_or_create_by(:name => 'Travel', :team => self, :default => true)
    ExpenseType.find_or_create_by(:name => 'Sponsorship', :team => self)
  end

  def set_subdomain
    self.subdomain = name.parameterize
  end

  def default_event_type
    event_types.where(:default => true).first
  end

  def default_attendee_type
    attendee_types.where(:default => true).first
  end

  def to_s
    self.name
  end

end
