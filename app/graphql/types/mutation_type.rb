class Types::MutationType < Types::BaseObject
  field :update_event, mutation: Mutations::Events::UpdateEvent

  field :create_attendee, mutation: Mutations::Attendees::CreateAttendee
  field :update_attendee, mutation: Mutations::Attendees::UpdateAttendee
  field :destroy_attendee, mutation: Mutations::Attendees::DestroyAttendee
end
