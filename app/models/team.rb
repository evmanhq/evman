class Team < ApplicationRecord

  has_many  :team_memberships, dependent: :delete_all
  has_many  :users, -> { distinct }, :through => :team_memberships
  has_many  :roles, dependent: :destroy
  has_one   :default_role, -> { where(default: true) }, class_name: 'Role'

  has_many  :team_events, dependent: :destroy
  has_many  :events, through: :team_events, dependent: :destroy
  has_many  :owned_events, inverse_of: :team, dependent: :destroy

  has_many :filter_bookmarks, dependent: :destroy, inverse_of: :team

  has_many  :event_types, dependent: :destroy
  has_many  :attendee_types, dependent: :destroy
  has_many  :expense_types, dependent: :destroy

  has_many  :talks, dependent: :destroy
  has_many :event_talks, :through => :events

  has_many  :tags, dependent: :destroy

  has_many  :team_invitations, dependent: :destroy
  has_many :forms, dependent: :destroy
  belongs_to :event_feedback_form, class_name: 'Form'

  has_one   :slack_setting, dependent: :destroy
  has_and_belongs_to_many :warehouses
  has_many :event_properties, inverse_of: :team, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :performance_metrics, inverse_of: :team, dependent: :destroy
  has_many :announcements, inverse_of: :team, dependent: :destroy

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

  def concerned_teams
    [self]
  end


end
