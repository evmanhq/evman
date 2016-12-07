module Authorization
  module Policies
    class AttendeePolicy < Base
      alias_method :attendee, :model
      def create?
        return true unless attendee.event

        team = attendee.event.team
        return true if dictator.can?(team, :event, :attend) and attendee.user == dictator.user
        return true if dictator.authorized?(attendee.event, :update)
        false
      end

      def destroy?
        create?
      end

    end
  end
end