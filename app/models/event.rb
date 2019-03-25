class Event < ApplicationRecord

  belongs_to  :team, inverse_of: :owned_events
  has_many    :team_events
  has_many    :teams, through: :team_events

  belongs_to  :city

  belongs_to  :event_type
  belongs_to  :event_series

  belongs_to  :owner, :class_name => 'User'

  has_many  :attendees, dependent: :destroy, inverse_of: :event
  has_many  :users, :through => :attendees, :as => :attendees

  has_many  :event_talks, dependent: :destroy
  has_many  :talks, :through => :event_talks
  has_many  :event_notes, dependent: :destroy, inverse_of: :event

  has_many :expenses, dependent: :destroy, inverse_of: :event

  has_many :attachments, :as => :parent, inverse_of: :parent, dependent: :destroy
  has_many :performance_metric_entries, dependent: :destroy, inverse_of: :event

  has_many  :taggeds, :as => :item, dependent: :destroy, inverse_of: :item
  has_many  :tags, -> { distinct }, :through => :taggeds
  has_many  :warehouse_transactions
  has_many :form_submissions, as: :associated_object
  has_and_belongs_to_many :contacts

  validates :name, presence: true
  validates :event_type, presence: true
  validates :owner, presence: true
  validates :team, presence: true
  validates :begins_at, presence: true
  validates :ends_at, presence: true
  validates :city, presence: true, if: proc{|e| e.new_record? or e.city_id_changed? }
  validates :location, presence: true, if: proc{|e| e.new_record? or e.location_changed? }

  ## Scopes
  scope :unarchived, -> { where(archived: [false, nil]) }
  # actual: Events that haven't started or finished
  scope :actual, -> { where('begins_at >= ? OR ends_at >= ?', Date.today, Date.today) }
  scope :committed, -> { where(committed: true).order(begins_at: :asc) }
  # tracked: Actual not committed events events
  scope :tracked, -> { actual.where(committed: [nil, false]).order(begins_at: :asc) }
  scope :within_cfp_deadline, -> { where('cfp_date >= ?', Date.today).order(cfp_date: :asc) }


  validates_with EventPropertyServices::EventValidator

  authorize_values_for :event_type
  authorize_values_for :owner
  authorize_values_for :team

  def full_location
    if city
      (self['location'] != nil && self['location'] != '') ? "#{self['location']}, #{city}" : city.to_s
    else
      self['location']
    end
  end

  def sponsored?
    true
  end

  def has_speakers?
    true
  end

  def to_s
    "#{name} owned by #{owner ? owner : 'unknown'}"
  end

  def label
    "#{name} (#{begins_at})"
  end

  def concerned_teams
    [team]
  end

  def concerned_users
    ([owner] + users.to_a).uniq
  end

  def urls
    @urls ||= [url, url2, url3].reject(&:blank?)
  end

  private

  # force keys and values to be strings in json
  before_validation :serialize_properties_assignments
  def serialize_properties_assignments
    return if properties_assignments.blank?
    self.properties_assignments = properties_assignments.each_with_object({}) do |args, memo|
      key, value = args
      memo[key.to_s] = Array.wrap(value).reject(&:blank?).map(&:to_s)
    end
  end

end
