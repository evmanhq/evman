class Types::AttendeeType < Types::BaseObject
  field :id, Integer, null: false
  field :user, Types::UserType, null: true, preload: { user: :teams }
  field :attendee_type, Types::AttendeeTypeType, null: false, preload: :attendee_type
end
