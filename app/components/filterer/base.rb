module Filterer
  class Base
    # === Dynamic filter using Vue components
    # @constrain_fields [Array] definition of filter fields
    # @sort_rule_fields [Array] definition of sort fields
    # @payload [Hash] hash containing constrains filled by user
    # Example:
    #
    #   constrain_fields = [
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
    #   ],
    #   sort_rule_fields = [
    #     {
    #       name: 'type',
    #       label: 'Event Type'
    #     }, ...
    #   ],
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
    #       sort_rules: [
    #         { name: 'name', direction: 'ASC' },
    #         { name: 'price', direction: 'DESC' },
    #       ],
    #       limit: 15,
    #       offset: 15
    #   }
    #
    # Every filterer should extend this class and provide implementation for @dispatch_filter
    # or use default behaviour of @dispatch_filter and implement methods matching columns definition

    include Helpers
    BASIC_TEXT_CONDITIONS = ['like', 'not_like', 'equals', 'begins']
    BASIC_MULTIPLE_CHOICE_CONDITIONS = ['any', 'all', 'none']
    BASIC_DATE_CONDITIONS = ['before', 'after', 'at', 'range']

    DEFAULT_UI_OPTIONS = {
        record_name: 'filter',
        trigger_change: false,
        show_submit: true,
        action_buttons: [],
        submit_text: 'Filter',
        sorting: true
    }

    DEFAULT_ACTION_BUTTON = {
        label: 'Label',
        path: nil,
        method: :post,
        class: '',
        icon: ''
    }

    attr_reader :constrain_fields, :payload, :sort_rule_fields, :ui_options
    def initialize(constrain_fields:, sort_rule_fields:, payload:, ui_options: {})
      @constrain_fields = build_constrain_fields(constrain_fields)
      @sort_rule_fields = build_sort_rule_fields(sort_rule_fields)
      @payload = payload
      @payload = @payload.with_indifferent_access if @payload.is_a? Hash
      set_ui_options(ui_options)
    end

    def links
      self.class.links
    end

    def apply_filters
      payload[:constrains].each do |data|
        next if data.values_at(:name, :values, :condition).any?(&:blank?)
        dispatch_filter(data[:name], data[:values], data[:condition])
      end if payload[:constrains]
      filter_finalizer

      payload[:sort_rules].each do |data|
        direction = data[:direction].upcase
        direction = 'ASC' unless ['ASC', 'DESC'].include?(direction)
        apply_sort_rule(data[:name], direction)
      end if payload[:sort_rules].present?

      apply_limit(payload[:limit]) if payload[:limit].present?
    end

    # Returns filtered records
    def filtered
      apply_filters
      @scope || []
    end

    # Definition for Javascript component
    def definition
      @definition ||= {
          constrain_fields: constrain_fields.as_json,
          sort_rule_fields: sort_rule_fields.as_json
      }
    end

    def to_partial_path
      'application/filterer'
    end

    def i18n_name
      self.class.i18n_name
    end

    def set_ui_options(ui_options)
      previous_options = @ui_options || DEFAULT_UI_OPTIONS
      options = (ui_options || {}).reject{|_,v| v.nil? }.slice(*DEFAULT_UI_OPTIONS.keys).reverse_merge(previous_options)
      options[:action_buttons].collect! do |button|
        button.slice(*DEFAULT_ACTION_BUTTON.keys).reverse_merge(DEFAULT_ACTION_BUTTON)
      end
      @ui_options = options
    end

    private

    # Default implementation of limit
    def apply_limit(limit)
      @scope = @scope.limit(limit)
    end

    def filter_finalizer
      # nothing
    end

    def dispatch_filter(name, values, condition)
      send("filter_#{name}", values, condition)
    end

    def apply_sort_rule(name, direction)
      send("sort_#{name}", direction)
    end

    def build_constrain_fields(constrain_fields)
      constrain_fields.collect do |field_definition|
        ConstrainField.new(field_definition.merge(filterer: self))
      end
    end

    def build_sort_rule_fields(order_rule_fields)
      order_rule_fields.collect do |field_definition|
        SortRuleField.new(field_definition.merge(filterer: self))
      end
    end
    
    class << self
      def add_link name:, icon:, &block
        @links ||= []
        @links << Filterer::Link.new(filterer_class: self, name: name, icon: icon, &block)
      end

      def links
        @links
      end

      def i18n_name
        self.name.split("::").last.underscore
      end
    end
  end
end