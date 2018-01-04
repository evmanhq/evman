module Authorization
  module Policies
    class FilterBookmarkPolicy < Base
      alias_method :filter_bookmark, :model

      def read?
        !!dictator.user
      end

      def create?
        read?
      end

      def update?
        filter_bookmark.owner == dictator.user
      end

      def destroy?
        update?
      end

      # Assignable attributes

      assignable_attribute :team do
        Array.wrap(dictator.team)
      end

      assignable_attribute :owner do
        dictator.team.users.all
      end
    end
  end
end