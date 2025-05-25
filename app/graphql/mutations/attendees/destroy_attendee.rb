class Mutations::Attendees::DestroyAttendee < Mutations::BaseMutation
  null true

  argument :attendee_id, ID, required: true

  field :event, Types::EventType, null: true
  field :global_errors, [String], null: false
  field :errors, [Types::AttributeErrorType], null: false

  def resolve(attendee_id:)
    attendee = Attendee.find(attendee_id)
    event = attendee.event

    if attendee.destroy
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
