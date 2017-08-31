module Filterer
  class Base
    # === Dynamic filter using Vue components
    # @definition [Array] definition of filter fields
    # @payload [Hash] hash containing constrains filled by user
    # Example:
    #
    #   definition = [
    #       {
    #           name:       'description',
    #           label:      'Event description', # optional, if specified, Filterer will not try to localize field name
    #           conditions: ['like', 'equals', 'gt', 'lt'],
    #           type:       'text', # number | multiple_choice
    #           options:     [ # in for multiple_choice select
    #                            { label: 'Ansible', value: 5 },
    #                            { label: 'Platform', value: 6 }
    #                        ],
    #           options_url: event_properties_path # get options from ajax
    #       }, ...
    #   ]
    #
    #
    #   payload = {
    #       constrains: [
    #                       {
    #                           name: 'description',
    #                           values: ['test part'], # array every time, even for single values
    #                           condition: 'like'
    #                       },
    #                       {
    #                           name: 'event_type',
    #                           values:    [1, 4, 6],
    #                           condition: 'includes'
    #                       }
    #                   ],
    #       order: {
    #           by: 'name',
    #           direction: 'ASC'
    #       },
    #       limit: 15,
    #       offset: 15
    #   }
    #
    # Every filterer should extend this class and provide implementation for @dispatch_filter
    # or use default behaviour of @dispatch_filter and implement methods matching columns definition

    include Helpers
    BASIC_TEXT_CONDITIONS = ['like', 'not_like', 'equals', 'begins']
    BASIC_MULTIPLE_CHOICE_CONDITIONS = ['all', 'none']

    attr_reader :fields, :payload
    def initialize(definition, payload)
      @fields = build_fields(definition)
      @payload = payload
    end

    def apply_filters
      payload[:constrains].each do |data|
        raise ArgumentError, 'missing payload key' if data.values_at(:name, :values, :condition).any?(&:blank?)
        dispatch_filter(data[:name], data[:values], data[:condition])
      end if payload[:constrains]
      filter_finalizer
      apply_order(payload[:order]) if payload[:order].present?
      apply_limit(payload[:limit]) if payload[:limit].present?
    end

    # Returns filtered records
    def filtered
      apply_filters
      @scope || []
    end

    # Definition for Javascript component
    def definition
      @definition ||= fields.as_json
    end

    # Default implementation of order
    def apply_order(order)
      @scope = @scope.order("#{order[:by]} #{order[:direction]}")
    end

    # Default implementation of limit
    def apply_limit(limit)
      @scope = @scope.limit(limit)
    end

    def to_partial_path
      'application/filterer'
    end

    def i18n_name
      self.class.name.split("::").last.underscore
    end

    private
    def filter_finalizer
      # nothing
    end

    def dispatch_filter(name, values, condition)
      send("filter_#{name}", values, condition)
    end

    def build_fields definition
      definition.collect do |field_definition|
        Field.new(field_definition.merge(filterer: self))
      end
    end
  end

  class Field
    TYPES = %w[text number multiple_choice date]

    attr_reader :name, :conditions, :type, :options, :options_url
    def initialize(name: nil, label: nil, conditions: [], type: nil, options: [], options_url: nil, filterer: nil)
      @name = name
      @label = label
      @filterer = filterer
      @conditions = build_conditions(conditions) if conditions.present?
      @type = type
      @options = options
      @options_url = options_url
    end

    def label
      return @label if @label
      defaults = [
          :"filterer.#{@filterer.i18n_name}.fields.#{name}",
          :"filterer.base.fields.#{name}",
          name.capitalize
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def as_json(opts={})
      json = {
          label: label,
          name: name,
          type: type,
          conditions: conditions.as_json
      }

      json[:options] = options if options.any?
      json[:options_url] = options_url if options_url.present?
      json
    end

    private
    def build_conditions(conditions)
      conditions.collect do |condition_definition|
        Condition.new(condition_definition, @filterer)
      end
    end
  end

  class Condition
    attr_reader :name
    def initialize(name, filterer)
      @name = name
      @filterer = filterer
    end

    def label
      defaults = [
          :"filterer.#{@filterer.i18n_name}.conditions.#{name}",
          :"filterer.base.conditions.#{name}",
          name
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def as_json(options={})
      {
          label: label,
          name: name
      }
    end
  end
end