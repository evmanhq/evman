module Authorization
  class PermissionGroup
    attr_reader :name
    def initialize name, data
      @name = name
      @data = data
    end

    def permission_names
      @data.keys
    end

    def method_missing name, *args
      if @data.has_key? name
        @data[name]
      else
        super
      end
    end
  end
end