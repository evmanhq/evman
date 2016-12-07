module Authorization
  module Policies
    class AttendeeTypePolicy < Base
      alias_method :attendee_type, :model
      def create?
        return true unless attendee_type.team

        team = attendee_type.team
        dictator.can?(team, :team, :attendee_types)
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