class Types::TeamType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :active, Boolean, null: false
  field :subdomain, String, null: false
  field :email_domain, String, null: true

  field :event_types, [Types::EventTypeType], null: false, preload: :event_types
  field :event_properties, [Types::EventPropertyType], null: false, preload: :event_properties

  field :attendee_types, [Types::AttendeeTypeType], null: false, preload: { attendee_types: :team }

  field :users, [Types::UserType], null: false, preload: { users: :teams }
  field :users_count, Integer, null: false, preload: :users
  def users_count
    users.size
  end
end
