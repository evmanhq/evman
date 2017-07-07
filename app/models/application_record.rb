class ApplicationRecord < ActiveRecord::Base
  include Authorization::ModelHelpers

  self.abstract_class = true

  if ENV['NOTIFICATIONS_URL']
    after_create do
      send_notification(:create, self)
    end

    after_update do
      send_notification(:update, self)
    end

    after_destroy do
      send_notification(:destroy, self)
    end

    def send_notification(event, instance)
      payload = {
          event: event,
          teams: instance.concerned_teams.map { |team| team.id },
          users: instance.concerned_users.map { |user| user.id },
          object: instance.class.name.downcase.singularize,
          id: instance.id,
      }

      response = notifications_connection.post do |req|
        req.url '/notification'
        req.headers['Content-Type'] = 'application/json'
        req.body = MultiJson.dump(payload)
      end
    rescue => e
      Raven.capture_exception(e)
    end

    def notifications_connection
      @notifications_connection ||= Faraday.new(:url => ENV['NOTIFICATIONS_URL']) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  :patron
      end
    end
  end

  def concerned_users
    return [user] if respond_to?(:user) && user
    return users if respond_to?(:users) && users.respond_to?(:to_a)
    []
  end

  def concerned_teams
    return [team] if respond_to?(:team) && team
    return teams if respond_to?(:teams) && teams.respond_to?(:to_a)
    []
  end

end
