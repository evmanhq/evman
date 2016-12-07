module Authorization
  module Policies
    class ExpenseTypePolicy < Base
      alias_method :expense_type, :model
      def create?
        return true unless expense_type.team

        team = expense_type.team
        dictator.can?(team, :team, :expense_types)
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