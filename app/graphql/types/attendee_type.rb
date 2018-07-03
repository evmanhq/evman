class Types::AttendeeType < Types::BaseObject
  field :id, Integer, null: false
  field :user, Types::UserType, null: false, preload: :user
  field :attendee_type, Types::AttendeeTypeType, null: false, preload: :attendee_type
end
