module Authorization
  module Policies
    class TagPolicy < Base
      alias_method :tag, :model

      def read?
        true
      end

      def create?
        dictator.can?(:team, :tags)
      end

      def destroy?
        dictator.can?(tag.team, :team, :tags)
      end
    end
  end
end