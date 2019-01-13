module Filterer
  class EventsFilterer < Base
    module FilterHelpers
      private
      def filter_name(values, condition)
        perform_filter_text('events.name', values, condition)
      end

      def filter_location(values, condition)
        perform_filter_text('events.location', values, condition)
      end

      def filter_url(values, condition)
        value = values.first
        columns = %w[events.url events.url2 events.url3 events.cfp_url]

        case condition
        when 'like' then
          where = columns.map{|c| "(#{c} ILIKE ?)"}.join(' OR ')
          @scope = @scope.where(where, *(["%#{value}%"] * columns.size))
        when 'not_like' then
          where = columns.map{|c| "(#{c} NOT ILIKE ?)"}.join(' OR ')
          @scope = @scope.where(where, *(["%#{value}%"] * columns.size))
        when 'begins' then
          where = columns.map{|c| "(#{c} ILIKE ?)"}.join(' OR ')
          @scope = @scope.where(where, *(["#{value}%"] * columns.size))
        when 'equals' then
          where = columns.map{|c| "(#{c} = ?)"}.join(' OR ')
          @scope = @scope.where(where, *([value] * columns.size))
        end
      end

      def filter_begins_at(values, condition)
        perform_filter_date('events.begins_at', values, condition)
      end

      def filter_ends_at(values, condition)
        perform_filter_date('events.ends_at', values, condition)
      end

      def filter_cfp_date(values, condition)
        perform_filter_date('events.cfp_date', values, condition)
      end

      def filter_sponsorship_date(values, condition)
        perform_filter_date('events.sponsorship_date', values, condition)
      end

      def filter_sponsorship(values, condition)
        perform_filter_text('events.sponsorship', values, condition)
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

      def filter_event_type(values, condition)
        case condition
        when 'any' then
          @scope = @scope.where(event_type_id: values)
        when 'none'
          @scope = @scope.where.not(event_type_id: values)
        end
      end

      def filter_city(values, condition)
        case condition
        when 'any'
          @scope = @scope.where(city_id: values)
        when 'none'
          @scope = @scope.where.not(city_id: values)
        end
      end

      def filter_committed(values, condition)
        perform_filter_boolean('events.committed', values, condition)
      end

      def filter_event_property(property, values, condition)
        if property.behaviour == EventProperty::Behaviour::TEXT
          perform_filter_text("properties_assignments->'#{property.id}'->>0", values, condition)
          return
        end

        case condition
        when 'all' then
          @scope = @scope.jsonb_where(:properties_assignments, { property.id.to_s => values})
        when 'none' then
          @scope = @scope.jsonb_where_not(:properties_assignments, { property.id.to_s => values})
        when 'any' then
          condition_scopes = values.collect do |value|
            Event.jsonb_where(:properties_assignments, { property.id.to_s => Array.wrap(value)})
          end
          or_scope = condition_scopes.shift
          condition_scopes.each do |condition_scope|
            or_scope = or_scope.or(condition_scope)
          end
          @scope = @scope.merge(or_scope)
        end
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
end