class Types::EventType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :committed, Boolean, null: true
  field :approved, Boolean, null: true
  field :archived, Boolean, null: true
  # field :city, Types::CityType

  # Strings
  [:location, :sponsorship, :cfp_url, :url, :url2, :url3, :description].each do |string_column|
    field string_column, String, null: true
  end
  field :full_location, String, null: false

  # Dates
  [:begins_at, :ends_at, :created_at, :cfp_date, :sponsorship_date].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: true
    define_method date_column do
      object.public_send(date_column).try(:to_time)
    end
  end

  # Methods
  field :full_location, String, null: true, preload: { city: [:state, :country, :english_city_name] }

  # Relationships
  field :owner, Types::UserType, null: false, preload: { owner: :team }
  field :attendees, [Types::AttendeeType], null: false, preload: :attendees
  field :team, Types::TeamType, null: false, preload: :team
  field :teams, [Types::TeamType], null: false, preload: :teams
  field :city, Types::CityType, null: true, preload: :city
  field :event_talks, [Types::EventTalkType], null: false, preload: :talks
  field :event_notes, [Types::EventNoteType], null: false, preload: :event_notes
  field :event_type, Types::EventTypeType, null: false, preload: :event_type

  field :event_property_assignments, [Types::EventPropertyAssignmentType], null: false

  def event_property_assignments
    event = object
    event.team.event_properties.includes(:options).in_order.map do |event_property|
      id = event_property.id
      label = event_property.name
      behaviour = event_property.behaviour
      values = case event_property.behaviour
                when EventProperty::Behaviour::MULTIPLE_CHOICE, EventProperty::Behaviour::SELECT
                  event_property.selected_options(event).map do |option|
                    EventPropertyAssignmentValue.new(option.id, option.name)
                  end
                when EventProperty::Behaviour::TEXT
                  event_property.values(event).map do |value|
                    EventPropertyAssignmentValue.new(nil, value)
                  end
                end

      # values = event_property.values(event)
      # value_ids = event.properties_assignments[id.to_s]
      EventPropertyAssignment.new(id, label, behaviour, values)
    end
  end

  EventPropertyAssignment = Struct.new(:id, :label, :behaviour, :values)
  EventPropertyAssignmentValue = Struct.new(:id, :label)
end
