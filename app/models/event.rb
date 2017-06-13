class Event < ApplicationRecord

  REJECTS = ['updated_at']

  belongs_to  :team, inverse_of: :events

  belongs_to  :city

  belongs_to  :event_type
  belongs_to  :event_series

  belongs_to  :owner, :class_name => 'User'

  has_many  :attendees
  has_many  :users, :through => :attendees, :as => :attendees

  has_many  :event_talks
  has_many  :talks, :through => :event_talks
  has_many  :event_notes

  has_many :expenses

  has_many :attachments, :as => :parent

  has_many  :taggeds, :as => :item
  has_many  :tags, -> { distinct }, :through => :taggeds
  has_many  :warehouse_transactions
  has_many :form_submissions, as: :associated_object

  validates :name, presence: true
  validates :event_type, presence: true
  validates :owner, presence: true
  validates :team, presence: true
  validates :begins_at, presence: true

  authorize_values_for :event_type
  authorize_values_for :owner
  authorize_values_for :team

  before_update do
    changes = self.changes.keys.reject { |k| REJECTS.include?(k) }
    if changes.length > 0
      changes = changes.map { |k| Event.human_attribute_name(k) }.join(',')

      mentions = [self.owner.slack_id(self.team)]
      mentions += self.attendees.all.map {|attendee| attendee.user.slack_id(self.team) }
      mentions = mentions.reject { |mention| mention == nil }.uniq.map { |member| "<@#{member}>"}.join(', ')

      Slack.post("Event <#{ENV['EVMAN_SCHEME']}://#{team.subdomain}.#{ENV['EVMAN_DOMAIN']}/events/#{self.id}|#{self.name}> was updated (#{changes}) /cc #{mentions}.", self.team)
    end
  end

  after_create do
    Slack.post("New event <#{ENV['EVMAN_SCHEME']}://#{team.subdomain}.#{ENV['EVMAN_DOMAIN']}/events/#{self.id}|#{self.name}> was created.", self.team)
  end

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
end
