module Authorization
  module Policies
    class TeamMembershipPolicy < Base
      alias_method :team_membership, :model
      def destroy?
        return true unless team_membership.team

        team = team_membership.team
        dictator.can?(team, :team, :members)
      end

    end
  end
end