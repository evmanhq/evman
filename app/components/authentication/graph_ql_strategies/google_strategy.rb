module Authentication
  module GraphQLStrategies
    class GoogleStrategy < Base
      URL = 'https://www.googleapis.com/oauth2/v3/tokeninfo'
      STATUS_OK = 200

      def self.provider
        'google'
      end

      def get_credentials
        conn = Faraday.new(URL, {
          headers: {
            'Authorization' => "Bearer #{access_token}"
          }
        })

        ret = conn.get
        return false unless ret.status == STATUS_OK
        json = JSON.parse(ret.body)

        Credentials.new(self.class.provider, json['sub'])
      end
    end
  end
end
