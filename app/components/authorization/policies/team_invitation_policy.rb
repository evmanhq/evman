module Authorization
  module Policies
    class TeamInvitationPolicy < Base
      alias_method :team_invitation, :model
      def create?
        return true unless team_invitation.team

        team = team_invitation.team
        dictator.can?(team, :team, :members)
      end

    end
  end
end