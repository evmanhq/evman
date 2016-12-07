module Authorization
  class Dictator

    attr_reader :user, :team, :active
    alias_method :active?, :active

    def initialize user, team
      @user, @team = user, team
      @active = false
    end

    def activate
      @active = true
    end

    def deactivate
      @active = false
    end

    ## Checks if a given action is allowed
    def authorized? *args
      return true unless active?

      case args.first
      when NilClass
        return true
      when Policies::Base
        policy = args.shift
        policy.authorize *args
      when ApplicationRecord, ActiveRecord::Base
        model = args.shift
        policy = policy_for model
        return true unless policy
        authorized? policy, *args
      when ActiveRecord::Relation, Array
        collection = args.shift
        collection.all? do |record|
          authorized? record, *args
        end
      else
        raise ArgumentError
      end
    end

    def authorize! *args
      result = authorized? *args
      return true if result

      case args.first
      when Policies::Base
        policy = args.shift
        raise UnauthorizedAccess.new(policy.model, *args)
      when ApplicationRecord, ActiveRecord::Base, ActiveRecord::Relation, Array
        raise UnauthorizedAccess.new(*args)
      else
        raise ArgumentError
      end
    end


    ## Checks if user has given permission in given (or current) team
    # Usage:
    # - can?(team, group, permission) - looks for permission in given team
    # - can?(group, permission) - looks for permission in current team
    def can? *args
      return true unless active?

      case args.first
      when Team
        used_team = args.shift
      when NilClass
        used_team = team
        args.shift
      else
        used_team = team
      end

      raise ArgumentError, "team, group permission or group, permission expected" if args.size != 2
      group, permission = args

      authorizes_roles?(used_team, group, permission) || authorizes_default_role?(used_team, group, permission)
    end

    def can! *args
      result = can? *args
      return true if result

      case args.first
      when Team
        used_team = args.shift
      else
        used_team = team
      end
      group, permission = args

      raise UnauthorizedAccess.new(group, permission, used_team)
    end

    def policy_for model
      policy_klass = find_policy model
      return nil unless policy_klass
      policy_klass.new model, self
    end

    private

    def authorizes_roles? team, group, permission
      user.roles.select{|r| r.team_id == team.id }.any?{ |role| role.can? group, permission }
    end

    def authorizes_default_role? team, group, permission
      return false unless user.teams.include? team
      return false unless team.default_role
      team.default_role.can? group, permission
    end

    def find_policy model
      policy_name = '::Authorization::Policies::' + model.class.name + 'Policy'
      policy_name.safe_constantize
    end
  end
end

# dictator.can? team, :event, :read