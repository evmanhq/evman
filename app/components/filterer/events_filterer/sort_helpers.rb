module Filterer
  class EventsFilterer < Base
    module SortHelpers
      private

      def sort_name(direction)
        @scope = @scope.order(name: direction)
      end

      def sort_event_type(direction)
        @scope = @scope.left_outer_joins(:event_type).order("event_types.name #{direction}")
      end

      def sort_city(direction)
        @scope = @scope.left_outer_joins(:city).order("cities.display #{direction}")
      end

      def sort_location(direction)
        @scope = @scope.order(location: direction)
      end

      def sort_begins_at(direction)
        @scope = @scope.order(begins_at: direction)
      end

      def sort_ends_at(direction)
        @scope = @scope.order(ends_at: direction)
      end

      def sort_cfp_date(direction)
        @scope = @scope.order(cfp_date: direction)
      end

      def sort_sponsorship_date(direction)
        @scope = @scope.order(sponsorship_date: direction)
      end

      def sort_event_property(event_property_id, direction)
        event_property = EventProperty.find(event_property_id)

        case event_property.behaviour
        when EventProperty::Behaviour::TEXT
          @scope = @scope.order("events.properties_assignments->'#{event_property_id}'->>0 #{direction}")
        when EventProperty::Behaviour::SELECT
          @scope = @scope.joins(<<-SQL).order("event_property_options.name #{direction}")
            LEFT OUTER JOIN event_property_options
            ON event_property_options.id = CAST(events.properties_assignments->'#{event_property_id}'->>0 AS INT)
          SQL
        else
          # nothing
        end
      end
    end
  end
end
