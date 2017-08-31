module Authentication
  class OmniauthAdapter
    attr_reader :data, :info, :credentials, :extra

    def initialize auth_data
      @data = auth_data.freeze
      @info = data[:info].freeze
      @credentials = @data[:credentials].freeze
      @extra = @data[:extra].freeze
    end

    def identity
      @identity ||= Identity.where(provider: data[:provider], uid: data[:uid]).first
    end

    def identity_exists?
      identity.present?
    end

    def register_user
      user = find_user_by_email
      unless user
        user = User.new(name:     info[:name],
                        email:    info[:email],
                        password: Digest::SHA256.hexdigest(SecureRandom.hex),
                        token:    Digest::SHA256.hexdigest(SecureRandom.hex))

        user.save!
      end
      register_identity(user)
      user
    end

    def register_identity user
      return false unless user
      identity = Identity.new provider: data[:provider],
                              user: user,
                              uid: data[:uid],
                              token: MultiJson.dump(credentials)

      if credentials[:expires]
        identity.expires = credentials[:expires_at]
      end

      identity.save!

      user.add_email info[:email]
      auto_register_team user, info[:email]
      true
    end

    private
    def find_user_by_email
      email = UserEmail.where(email: info[:email]).first
      return email.user if email
      User.where(email: info[:email]).first
    end

    # Saves email if user does not have already
    def assure_email user
      return true if user.emails.where(email: info[:email]).any?
      email = UserEmail.new(active: true,
                            email:  info[:email],
                            user:   user)
      email.save!
      auto_register_team(email)
    end

    def auto_register_team user, email
      parts = email.to_s.split('@')
      return if parts.length <= 1
      domain = parts.last
      team = Team.where(email_domain: domain).first
      return unless team
      return if TeamMembership.where(user: user, team: team).any?

      membership = TeamMembership.new team: team,
                                      user: user,
                                      active: true
      membership.save!
    end
  end
end