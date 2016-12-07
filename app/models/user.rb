class User < ApplicationRecord

  has_secure_password

  include Rails.application.routes.url_helpers

  belongs_to  :team
  has_many  :identities

  has_many  :team_invitations
  has_many  :team_memberships
  has_many  :teams, :through => :team_memberships

  has_and_belongs_to_many :roles

  has_many  :attendees
  has_many  :events, :through => :attendees

  has_many :event_talks
  has_many :talks

  has_many  :slack_users
  has_many :biographies, inverse_of: :user
  belongs_to :default_biography, class_name: 'Biography'
  has_many :profile_pictures, inverse_of: :user
  belongs_to :default_profile_picture, class_name: 'ProfilePicture'

  belongs_to :home_country, class_name: 'Country'

  has_many  :emails, class_name: 'UserEmail'

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

  def self.o_auth(info, current_user)
    uid = info[:uid]
    identity = Identity.find_by_uid(uid)

    unless identity
      email = UserEmail.where(email: info[:info][:email]).first

      if email
        user = email.user
      else
        if current_user
          user = current_user
        else
          user = User.new
          user.name = info[:info][:name]
          user.email = info[:info][:email]
          user.password = SecureRandom.hex
          user.save!
        end

        email = UserEmail.new
        email.active = true
        email.email = info[:info][:email]
        email.user = user
        email.save!

        parts = email.email.to_s.split('@')
        if parts.length > 1
          domain = parts[1]
          team = Team.where(email_domain: domain).first

          if team && !TeamMembership.where(user: email.user, team: team).first
            @membership = TeamMembership.new
            @membership.team = team
            @membership.user = email.user
            @membership.active = true
            @membership.team_membership_type = TeamMembershipType.find_by_name('Owner')
            @membership.save
          end

        end
      end

      identity = Identity.new
      identity.provider = info[:provider]
      identity.user = user

      identity.uid = info[:uid]
      identity.token = info[:credentials][:token]
      identity.secret = info[:credentials][:secret]

      if info[:credentials][:expires]
        identity.expires = info[:credentials][:expires_at]
      end

      identity.save
    end

    identity.user
  end

  def avatar_url(size=38)
    if default_profile_picture
      download_profile_picture_path(default_profile_picture, type: :thumb)
    else
      "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.email)}?width=#{size}"
    end

  end

  def to_s
    "#{name} (#{email})"
  end

end
