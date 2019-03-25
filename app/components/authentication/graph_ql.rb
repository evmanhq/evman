module Authentication
  class GraphQL
    include Singleton

    attr_reader :strategies
    def initialize
      @strategies = []
      @strategies << GraphQLStrategies::GoogleStrategy
    end

    def authenticate(provider, access_token)
      strategy_class = strategies.find{|s| s.provider == provider }
      return :unsupported_strategy unless strategy_class

      strategy = strategy_class.new(access_token)
      cred = strategy.get_credentials
      return :unauthorized unless cred

      identity = Identity.where(provider: cred.provider, uid: cred.uid).first
      return :unregistered unless identity

      identity.user
    end
  end
end