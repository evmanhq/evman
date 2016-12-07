module Authorization
  module Policies
    class EventTypePolicy < Base
      alias_method :event_type, :model
      def create?
        return true unless event_type.team

        team = event_type.team
        dictator.can?(team, :team, :event_types)
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