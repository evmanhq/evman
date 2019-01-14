class Mutations::Events::Update < Mutations::BaseMutation
  null true

  argument :event_id, ID, required: true
  argument :attributes, Types::EventAttributes, required: true

  field :event, Types::EventType, null: true
  field :errors, [String], null: false

  def resolve(event_id:, attributes:)
    event = Event.find(event_id)

    event.approved = attributes.approved if attributes.approved != nil
    event.committed = attributes.committed if attributes.committed != nil

    if event.save
      {
          event: event,
          errors: []
      }
    else
      {
        errors: event.errors.full_messages
      }
    end
  end

end