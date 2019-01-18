class Mutations::Events::Update < Mutations::BaseMutation
  null true

  argument :event_id, ID, required: true
  argument :attributes, Types::EventAttributes, required: true

  field :event, Types::EventType, null: true
  field :global_errors, [String], null: false
  field :errors, [Types::AttributeErrorType], null: false

  def resolve(event_id:, attributes:)
    event = Event.find(event_id)

    # Booleans
    [:approved, :committed, :archived].each do |column|
      next unless attributes.key? column
      new_value = attributes.public_send(column)
      event.public_send("#{column}=", new_value)
    end

    # Strings
    [:name, :location, :sponsorship, :cfp_url, :url, :url2, :url3, :description].each do |column|
      next unless attributes.key? column
      new_value = attributes.public_send(column)
      event.public_send("#{column}=", new_value)
    end

    # Integers
    [:event_type_id].each do |column|
      next unless attributes.key? column
      new_value = attributes.public_send(column)
      event.public_send("#{column}=", new_value)
    end

    # Dates
    [:begins_at, :ends_at, :cfp_date, :sponsorship_date].each do |column|
      next unless attributes.key? column
      new_value = attributes.public_send(column)
      event.public_send("#{column}=", new_value )
    end

    if event.save
      {
          event: event,
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
  AttributeError = Struct.new(:name, :messages)
end
