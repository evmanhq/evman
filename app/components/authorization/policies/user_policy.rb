module Authorization
  module Policies
    class UserPolicy < Base
      alias_method :user, :model

      def read?
        dictator.user.teams.any? do |team|
          dictator.can? team, :team, :members_read
        end
      end
    end
  end
end