module Filterer
  class EventsFilterer < Base
    def initialize(scope: nil, payload: {}, current_team: nil)
      raise ArgumentError, 'current_team' unless current_team
      @scope = scope || current_team.events
      definition = [
          {
              name: 'name',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'description',
              type: 'text',
              conditions: ['fulltext','like']
          },

          {
              name: 'event_type',
              type: 'multiple_choice',
              conditions: BASIC_MULTIPLE_CHOICE_CONDITIONS,
              options: current_team.event_types.order(:name).map{|t| { value: t.id, label: t.name }}
          }
      ]

      # Builds definition for event_properties
      current_team.event_properties.includes(:options).each do |property|
        define_event_property(property, definition)
      end

      super(definition, payload)
    end

    private

    # helper for building definition
    def define_event_property(property, definition)
      conditions = {
          'text' => BASIC_TEXT_CONDITIONS,
          'multiple_choice' => BASIC_MULTIPLE_CHOICE_CONDITIONS
      }

      definition << {
          name: "event_property_#{property.id}",
          label: property.name,
          type: property.behaviour,
          conditions: conditions[property.behaviour],
          options: property.options.order(:name).collect{|o| { label: o.name, value: o.id} }
      }
    end

    # custom dispatch filter to handle event_properties
    def dispatch_filter(name, values, condition)
      case name
      when /event_property_(\d+)/
        register_event_property_filter($1, values, condition)
      else
        super
      end
    end

    def filter_name(values, condition)
      perform_filter_text('events.name', values, condition)
    end

    def filter_description(values, condition)
      value = values.first
      case condition
      when 'fulltext' then
        q = value.split(' ').map { |item| item  + ':*' }.join('&')
        @scope = @scope.where('to_tsvector(\'english\', f_unaccent(events.description)) @@ to_tsquery(unaccent(?))', q)
      else
        perform_filter_text('events.description', values, condition)
      end
    end

    def filter_event_property(property, values, condition)
      if property.behaviour == EventProperty::Behaviour::TEXT
        perform_filter_text("properties_assignments->'#{property.id}'->>0", values, condition)
        return
      end

      case condition
      when 'all' then
        @scope = @scope.jsonb_where(:properties_assignments, { property.id.to_s => values})
      when 'none'
        @scope = @scope.jsonb_where_not(:properties_assignments, { property.id.to_s => values})
      end
    end

    # first register event property filters to avoid N+1 queries
    def register_event_property_filter(id, values, condition)
      @event_property_filters ||= []
      @event_property_filters << { id: id, values: values, condition: condition}
    end

    # efficiently apply event property filters in finalizer
    def filter_finalizer
      load_event_properties

      return if @event_property_filters.blank?

      @event_property_filters.each do |filter|
        event_property = @event_properties[filter[:id]]
        filter_event_property(event_property, filter[:values], filter[:condition])
      end
    end

    # preload registered event properties in one select
    def load_event_properties
      return if @event_property_filters.blank?
      @event_properties = EventProperty.find(@event_property_filters.collect{|f| f[:id] })
                              .each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |property, obj|
        obj[property.id.to_s] = property
      end
    end
  end
end