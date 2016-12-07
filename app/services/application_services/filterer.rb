module ApplicationServices
  class Filterer
    attr_reader :dictator, :scope, :filters
    def initialize dictator, scope, filters=nil
      @scope = scope.dup
      @dictator = dictator
      @filters = Array.wrap(filters).collect{ |f| Filter.new(f) }
    end

    def filtered
      apply_filters
      scope
    end

    private

    def apply_filters
      @filters.each do |filter|
        dispatch_filter filter
      end
    end

    def dispatch_filter filter
      raise StandardError, 'implement in subclass'
      # case filter.name
      # when 'event_name' then filter_event_name(filter)
      # when 'event_date' then filter_event_date(filter)
      # end
    end

    def delete_filter filter
      @filters.delete filter
    end

    class Filter
      attr_reader :name, :params, :applied
      alias_method :applied?, :applied
      def initialize data
        data = data.dup
        @name = data.delete(:name).to_sym
        raise ArgumentError, 'name is required' if name.blank?
        @params = ActiveSupport::HashWithIndifferentAccess.new(data)
        @applied = false
      end

      def applied!
        @applied = true
      end

      def to_json
        params.merge({name: name}).to_json
      end

      def method_missing name, *args, &block
        super if args.size != 0 or !params.key? name
        params[name]
      end
    end
  end
end


[
    {
        name: "events.name",
        sign: "=",
        value: "DevConf"
    },
    {
        name: "events.date",
        begin: '2016-01-01',
        end: '2016-09-01'

    }
]