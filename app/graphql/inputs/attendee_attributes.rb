class Inputs::AttendeeAttributes < Types::BaseInputObject
  description "Attributes for creating or updating an attendee"

  argument :event_id, ID, required: true
  argument :user_id, ID, required: true
  argument :attendee_type_id, ID, required: true
end
