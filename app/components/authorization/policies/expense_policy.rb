module Authorization
  module Policies
    class ExpensePolicy < Base
      alias_method :expense, :model
      def read?
        return true unless expense.event
        dictator.authorized? expense.event, :read
      end

      def create?
        return true unless expense.event

        return true if dictator.authorized?(expense.event, :read) and expense.user == dictator.user
        return true if dictator.authorized?(expense.event, :update)
        false
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