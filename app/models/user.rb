class User < ApplicationRecord

  has_secure_password

  include Rails.application.routes.url_helpers

  has_many  :identities, dependent: :destroy

  has_many  :team_invitations
  has_many  :team_memberships, dependent: :destroy
  has_many  :teams, :through => :team_memberships

  has_and_belongs_to_many :roles

  has_many  :attendees
  has_many  :events, :through => :attendees
  has_many :filter_bookmarks, foreign_key: :owner_id, dependent: :destroy, inverse_of: :owner

  has_many :event_talks
  has_many :talks

  has_many  :slack_users
  has_many :biographies, inverse_of: :user
  belongs_to :default_biography, class_name: 'Biography'
  has_many :profile_pictures, inverse_of: :user
  belongs_to :default_profile_picture, class_name: 'ProfilePicture'

  belongs_to :home_country, class_name: 'Country'

  has_many  :emails, class_name: 'UserEmail', dependent: :destroy
  has_many :announcement_users, inverse_of: :user, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2 }

  def slack_id(team)
    u = slack_users.where(:slack_setting => team.slack_setting).first
    return u.username if u
    nil
  end

  def accepted_talks
    event_talks.where(:state => true)
  end

  def next_cfp(team)
    team.events.limit(1).order('events.cfp_date').where('cfp_date >= ?', Date.today).first
  end

  def next_event
    events.limit(1).order('events.begins_at').where('begins_at >= ?', Date.today).first
  end

  def assure_credentials
    self.token ||= Digest::SHA256.hexdigest(SecureRandom.hex)
    self.password = Digest::SHA256.hexdigest(SecureRandom.hex) unless password_digest
    save
  end

  def add_email email
    return if emails.where(email: email).any?
    emails.create(active: true, email:  email)
  end

  def avatar_url(size=38)
    if default_profile_picture
      download_profile_picture_path(default_profile_picture, type: :thumb)
    else
      "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?width=#{size}"
    end

  end

  def concerned_users
    [self]
  end

  def to_s
    "#{name} (#{email})"
  end

end
