class Types::EventType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :committed, Boolean, null: false
  field :approved, Boolean, null: false
  field :archived, Boolean, null: false
  # field :city, Types::CityType

  # Strings
  [:location, :sponsorship, :cfp_url, :url, :url2, :url3, :description].each do |string_column|
    field string_column, String, null: false
  end
  field :full_location, String, null: false

  # Dates
  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
  [:cfp_date, :sponsorship_date].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: true
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

  field :event_property_assignments, [Types::EventPropertyAssignmentType], null: false

  def event_property_assignments
    event = object
    event.team.event_properties.includes(:options).in_order.map do |event_property|
      label = event_property.name
      behaviour = event_property.behaviour
      values = event_property.values(event)
      EventPropertyAssignment.new(label, behaviour, values)
    end
  end

  EventPropertyAssignment = Struct.new(:label, :behaviour, :values)
end