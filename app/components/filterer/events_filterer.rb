module Filterer
  class EventsFilterer < Base
    include Rails.application.routes.url_helpers
    include FilterHelpers
    include SortHelpers

    add_link(name: 'calendar', icon: 'calendar') do |bookmark|
      private_link calendars_path(filter_bookmark_code: bookmark.code)
      public_link public_calendars_path(filter_bookmark_code: bookmark.code)
    end

    add_link(name: 'list', icon: 'list') do |bookmark|
      private_link list_events_path(filter_bookmark_code: bookmark.code)
    end

    add_link(name: 'export', icon: 'table') do |bookmark|
      private_link export_events_path(filter_bookmark_code: bookmark.code)
    end


    def initialize(scope: nil, payload: {}, current_team: nil)
      raise ArgumentError, '`current_team` is required' unless current_team
      payload ||= {}

      @scope = scope || current_team.events
      @scope = @scope.merge(current_team.events)
      constrain_fields = [
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
              conditions: ['any', 'none'],
              options: current_team.event_types.order(:name).map{|t| { value: t.id.to_s, label: t.name }}
          },

          {
              name: 'city',
              type: 'multiple_choice',
              conditions: ['any', 'none'],
              options_url: geo_cities_path
          },

          {
              name: 'location',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'url',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },

          {
              name: 'begins_at',
              type: 'date',
              conditions: BASIC_DATE_CONDITIONS
          },

          {
              name: 'ends_at',
              type: 'date',
              conditions: BASIC_DATE_CONDITIONS
          },

          {
              name: 'cfp_date',
              type: 'date',
              conditions: BASIC_DATE_CONDITIONS
          },

          {
              name: 'sponsorship_date',
              type: 'date',
              conditions: BASIC_DATE_CONDITIONS
          },

          {
              name: 'sponsorship',
              type: 'text',
              conditions: BASIC_TEXT_CONDITIONS
          },
          {
              name: 'committed',
              type: 'multiple_choice',
              conditions: BASIC_MULTIPLE_CHOICE_CONDITIONS,
              options: [{ value: 'true', label: 'Yes'}, { value: 'false', label: 'No'}, { value: 'nil', label: 'Not decided'}]
          },


      ]


      sort_rule_fields = [
          { name: 'name' },
          { name: 'event_type' },
          { name: 'city' },
          { name: 'location' },
          { name: 'begins_at' },
          { name: 'ends_at' },
          { name: 'cfp_date' },
          { name: 'sponsorship_date' }
      ]
      # Builds definition for event_properties
      current_team.event_properties.in_order.includes(:options).each do |property|
        define_event_property_constrain(property, constrain_fields)

        if [EventProperty::Behaviour::TEXT, EventProperty::Behaviour::SELECT].include?(property.behaviour)
          define_event_property_sort_rule(property, sort_rule_fields)
        end
      end

      super(constrain_fields: constrain_fields,
            sort_rule_fields: sort_rule_fields,
            payload: payload)
    end

    private

    # helper for building definition
    def define_event_property_constrain(property, constrain_fields)
      conditions = {
          'text' => BASIC_TEXT_CONDITIONS,
          'multiple_choice' => BASIC_MULTIPLE_CHOICE_CONDITIONS,
          'select' => BASIC_MULTIPLE_CHOICE_CONDITIONS
      }

      property_conditions = conditions[property.behaviour]
      raise StandardError, "no conditions defined for behaviour: #{property.behaviour}" if property_conditions.nil?

      constrain_fields << {
          name: "event_property_#{property.id}",
          label: property.name,
          type: property.behaviour,
          conditions: property_conditions,
          options: property.options.collect{|o| { label: o.name, value: o.id.to_s} }
      }
    end

    def define_event_property_sort_rule(property, sort_rule_fields)
      sort_rule_fields << {
          name: "event_property_#{property.id}",
          label: property.name
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

    # first register event property filters to avoid N+1 queries
    def register_event_property_filter(id, values, condition)
      @event_property_filters ||= []
      @event_property_filters << { id: id, values: values, condition: condition}
    end

    def apply_sort_rule(name, direction)
      case name
      when /event_property_(\d+)/
        sort_event_property($1, direction)
      else
        super
      end
    end
  end
end