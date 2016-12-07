module Authorization
  class UnauthorizedAccess < StandardError
    attr_reader :record, :action, :team, :group, :permission, :parameters, :collection
    def initialize *args
      case args.first
      when ApplicationRecord, ActiveRecord::Base
        @record, @action = args[0..1]
        @parameters = args[2..-1]
      when ActiveRecord::Relation, Array
        @collection, @action = args[0..1]
        @parameters = args[2..-1]
      when Symbol
        @group, @permission, @team = args
      else
        raise ArgmuentError
      end
    end

    def with_record?
      record.present?
    end

    def with_permission?
      group.present? && permission.present?
    end

    def with_collection?
      collection.present?
    end
  end
end