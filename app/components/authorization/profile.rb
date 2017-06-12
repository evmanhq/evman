module Authorization
  class Profile
    DEFAULT = {
        event: {
            read: true,
            attend: true,
            manage: true,
            manage_all: false,
        },

        team: {
            event_types: false,
            attendee_types: false,
            expense_types: false,
            slack_integration: false,
            tags: false,
            members_read: true,
            members: false,
            goals: true,
            statistics: true,
            tasks: true,
            forms: true
        },

        talk: {
            read: true,
            manage: true,
            manage_all: false
        },

        warehouse: {
            read: true
        },

        role: {
            read: false,
            manage: false
        }
    }.with_indifferent_access

    # Required for ActiveRecord::AttributeMethods::Serialization
    def self.load data
      self.new data
    end

    def self.dump profile
      profile.dump
    end

    def initialize data = nil
      @data = data || {}
      @data = @data.with_indifferent_access
      @data = DEFAULT.deep_merge(@data)
      clean_unspecified_permissions @data
      booleanize_values @data
      set_default_to_false @data
    end

    def authorized? group, permission
      return false unless @data[group]
      @data[group][permission]
    end

    def dump
      @data
    end

    def groups
      @data.keys.collect do |group_name|
        PermissionGroup.new(group_name, @data[group_name])
      end
    end

    def granted_permissions_count
      count = 0
      @data.each do |group_name, group|
        group.each do |right_name, right_value|
          count += 1 if right_value
        end
      end
      count
    end

    def allow_all
      @data.each do |group_name, group|
        group.each do |right_name, right_value|
          @data[group_name][right_name] = true
        end
      end
      true
    end

    private

    def clean_unspecified_permissions data
      data.delete_if{|k,v| !DEFAULT.has_key?(k) }
      data.keys.each do |g|
        data[g].delete_if{|k,v| !DEFAULT[g].has_key?(k) }
      end
    end

    def booleanize_values data
      data.keys.each do |group|
        data[group].keys.each do |perm|
          data[group][perm] = data[group][perm] == '1' if data[group][perm].is_a? String
        end
      end
    end

    def set_default_to_false data
      data.each do |_, value|
        set_default_to_false value if value.is_a? Hash
      end
      data.default = false
    end
  end
end