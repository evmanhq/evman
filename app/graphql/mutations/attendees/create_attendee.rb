class Mutations::Attendees::CreateAttendee < Mutations::BaseMutation
  null true

  argument :attributes, Inputs::AttendeeAttributes, required: true

  field :event, Types::EventType, null: true
  field :global_errors, [String], null: false
  field :errors, [Types::AttributeErrorType], null: false

  def resolve(attributes:)
    event = Event.find(attributes.event_id)

    attendee = event.attendees.build(
      user_id: attributes.user_id,
      attendee_type_id: attributes.attendee_type_id
    )

    if attendee.save
      {
          event: event.reload,
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
