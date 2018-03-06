class TeamDumpSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :created_at, :subdomain, :email_domain

  has_many :users
  has_many :events
  has_many :talks
  has_many :event_types
  has_many :attendee_types
  has_many :expense_types
  has_many :forms
  has_many :contacts
  has_many :performance_metrics
  has_many :roles
end