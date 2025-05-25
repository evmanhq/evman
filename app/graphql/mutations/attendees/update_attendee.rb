class Mutations::Attendees::UpdateAttendee < Mutations::BaseMutation
  null true

  argument :attendee_id, ID, required: true
  argument :attributes, Inputs::AttendeeAttributes, required: true

  field :event, Types::EventType, null: true
  field :global_errors, [String], null: false
  field :errors, [Types::AttributeErrorType], null: false

  def resolve(attendee_id:, attributes:)
    attendee = Attendee.find(attendee_id)

    attendee.attributes = {
      user_id: attributes.user_id,
      attendee_type_id: attributes.attendee_type_id
    }

    if attendee.save
      {
          event: attendee.event.reload,
          global_errors: [],
          errors: []
      }
    else
      {
        errors: event.errors.messages.map{|field, messages| AttributeError.new(field, messages)},
        global_errors: event.errors.messages[:base]
      }
    end
  end
end
