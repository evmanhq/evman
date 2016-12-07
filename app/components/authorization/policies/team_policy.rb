module Authorization
  module Policies
    class TeamPolicy < Base
      alias_method :team, :model

      def read_members?
        dictator.can? team, :team, :members_read
      end

      def settings?
        dictator.can?(team, :team, :event_types) ||
          dictator.can?(team, :team, :attendee_types) ||
          dictator.can?(team, :team, :expense_types) ||
          dictator.can?(team, :team, :slack_integration)
      end
    end
  end
end