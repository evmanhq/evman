module Authorization
  module Policies
    class TalkPolicy < Base
      alias_method :talk, :model

      def read?
        dictator.can? talk.team, :talk, :read
      end

      def create?
        dictator.can?(:talk, :manage) || dictator.can?(:talk, :manage_all)
      end

      def update?
        return true if dictator.can?(talk.team, :talk, :manage) && dictator.user == talk.user
        return true if dictator.can?(talk.team, :talk, :manage_all)
        false
      end

      def destroy?
        update?
      end

      # Assignable attributes

      assignable_attribute :team do
        Array.wrap(dictator.team)
      end

      assignable_attribute :user do
        if dictator.can?(talk.team, :talk, :manage_all)
          dictator.team.users.all
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