module EventServices
  class Exporter
    include ActiveModel::Model

    module ExportType
      XLS = 'xls'
      CSV = 'csv'
    end
    EXPORT_TYPES = [ExportType::XLS, ExportType::CSV]

    class Field
      attr_reader :name, :definition
      def initialize name, label=nil, &block
        @name, @label, @definition = name, label, block
        @definition ||= proc {|event| event.send(name) }
      end

      def label
        @label || name.humanize
      end
    end

    EXPORT_FIELDS = [
        Field.new('id'),
        Field.new('name'),
        Field.new('description'),
        Field.new('committed'),
        Field.new('approved'),
        Field.new('archived'),
        Field.new('location'),
        Field.new('url'),
        Field.new('url2'),
        Field.new('url3'),
        Field.new('sponsorship'),
        Field.new('cfp_url'),
        Field.new('cfp_date'),
        Field.new('begins_at'),
        Field.new('ends_at'),
        Field.new('created_at'),
        Field.new('updated_at'),
        Field.new('last_updated_by') {|event| event.versions.last.try(:actor).try(:name) },
        Field.new('sponsorship_date'),
        # Associat'ons'
        Field.new('city') {|event| event.city.to_s },
        Field.new('owner') { |event| event.owner.name },
        Field.new('event_type') {|event| event.event_type.name },
    ]


    def self.model_name
      ActiveModel::Name.new(self, nil, "Exporter")
    end

    validates :export_type, presence: true, inclusion: { in: EXPORT_TYPES }
    validates :fields, presence: true

    attr_reader :export_type, :team, :fields
    def initialize team, args={}
      @team = team
      @fields = args[:fields] || []
      @export_type = args[:export_type] || ExportType::XLS
    end

    def available_fields
      @available_fields ||= begin
        available_fields = EXPORT_FIELDS + team.event_properties.includes(:options).in_order.collect do |event_property|
          Field.new("event_property_#{event_property.id}", event_property.name) do |event|
            event_property.values(event).join(', ')
          end
        end
        available_fields
      end
    end

    def available_export_types
      EXPORT_TYPES
    end

    def selected_fields
      @selected_fields ||= available_fields.select do |available_field|
        fields.include?(available_field.name)
      end
    end

    def export(events)
      events = events.includes(:city, :owner, :event_type)
      serialized_events = events.collect do |event|
        serialize_event(event)
      end

      renderer = case export_type
                 when ExportType::XLS then
                   ExportRenderer::XLS.new(selected_fields.map(&:label), serialized_events)
                 when ExportType::CSV then
                   ExportRenderer::CSV.new(selected_fields.map(&:label), serialized_events)
                 else
                   raise StandardError, "unknown export type: #{export_type}"
                 end

      renderer.render
    end

    def persisted?
      false
    end

    private
    def serialize_event(event)
      selected_fields.collect do |field|
        field.definition.call(event)
      end
    end
  end
end