class UserDumpSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at, :updated_at, :job_title, :organization, :phone, :twitter, :github

  has_many :emails
  has_many :teams
  has_many :events, key: :attended_events
  has_many :talks
  has_many :biographies
end