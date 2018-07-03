class Types::EventType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :committed, Boolean, null: false
  field :approved, Boolean, null: false
  field :archived, Boolean, null: false
  # field :city, Types::CityType
  field :location, String, null: false
  field :attendees, [Types::AttendeeType], null: false, preload: :attendees
  field :begins_at, GraphQL::Types::ISO8601DateTime, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
end
