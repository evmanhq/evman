module Authorization
  module Policies
    class EventPolicy < Base
      alias_method :event, :model
      def read?
        dictator.can? event.team, :event, :read
      end

      def create?
        dictator.can?(:event, :manage) || dictator.can?(:event, :manage_all)
      end

      def update?
        return true if dictator.can?(event.team, :event, :manage) && dictator.user == event.owner
        return true if dictator.can?(event.team, :event, :manage_all)
        false
      end

      def destroy?
        update?
      end

      assignable_attribute :team do
        Array.wrap(dictator.team)
      end

      assignable_attribute :owner do
        if dictator.can?(event.team, :event, :manage_all)
          dictator.team.users
        else
          dictator.team.users.where(id: dictator.user.id)
        end
      end

      assignable_attribute :event_type do
        dictator.team.event_types
      end
    end
  end
end