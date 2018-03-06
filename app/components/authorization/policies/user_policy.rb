module Authorization
  module Policies
    class UserPolicy < Base
      alias_method :user, :model

      def signed_in?
        user == dictator.user
      end

      def read?
        signed_in? or user.teams.any? do |team|
          dictator.can? team, :team, :members_read
        end
      end

      def update?
        signed_in?
      end

      def destroy?
        signed_in?
      end

      def dump?
        signed_in?
      end
    end
  end
end