module Authorization
  module Policies
    class EventPolicy < Base
      alias_method :event, :model
      def read?
        event.teams.each do |team|
          return true if dictator.can? team, :event, :read
        end

        false
      end

      def create?
        dictator.can?(:event, :manage) || dictator.can?(:event, :manage_all)
      end

      def update?
        event.teams.each do |team|
          return true if dictator.can?(team, :event, :manage) && dictator.user == event.owner
          return true if dictator.can?(team, :event, :manage_all)
        end
        false
      end

      def destroy?
        update?
      end

      def approve?
        dictator.can?(:event, :approve)
      end

      def commit?
        dictator.can?(:event, :commit)
      end

      assignable_attribute :team do
        Array.wrap(dictator.team)
      end

      assignable_attribute :owner do
        if event.teams.map { |team| dictator.can?(team, :event, :manage_all) }.include?(true)
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