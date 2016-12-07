module Authorization
  module Policies
    class EventTalkPolicy < Base
      alias_method :event_talk, :model
      def create?
        return true unless event_talk.event

        return true if dictator.authorized?(event_talk.event, :read) and event_talk.user == dictator.user
        return true if dictator.authorized?(event_talk.event, :update)
        false
      end

      def update?
        create?
      end

      def destroy?
        create?
      end

    end
  end
end