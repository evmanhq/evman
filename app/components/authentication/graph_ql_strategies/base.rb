module Authentication
  module GraphQLStrategies
    class Base

      attr_reader :access_token
      def initialize(access_token)
        @access_token = access_token
      end

      def self.provider
        raise NameError, 'implement in subclass'
      end

      def get_credentials
        raise NameError, 'implement in subclass'
      end
    end

    Credentials = Struct.new(:provider, :uid)
  end
end
