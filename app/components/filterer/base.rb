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
    BASIC_MULTIPLE_CHOICE_CONDITIONS = ['any', 'all', 'none']
    BASIC_DATE_CONDITIONS = ['before', 'after', 'at', 'range']

    DEFAULT_UI_OPTIONS = {
        record_name: 'filter',
        trigger_change: false,
        show_submit: true,
        action_buttons: [],
        submit_text: 'Filter'
    }

    DEFAULT_ACTION_BUTTON = {
        label: 'Label',
        path: nil,
        method: :post,
        class: '',
        icon: ''
    }

    attr_reader :fields, :payload, :ui_options
    def initialize(definition, payload, ui_options={})
      @fields = build_fields(definition)
      @payload = payload
      @payload = @payload.with_indifferent_access if @paylod.is_a? Hash
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
    # Default implementation of order
    def apply_order(order)
      @scope = @scope.order("#{order[:by]} #{order[:direction]}")
    end

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

    def build_fields definition
      definition.collect do |field_definition|
        Field.new(field_definition.merge(filterer: self))
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