class Types::QueryType < Types::BaseObject
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # TODO: remove me
  field :test_field, String, null: false,
    description: "An example field added by the generator"
  def test_field
    "Hello World!"
  end

  field :events, [Types::EventType], null: false, description: "List all events" do
    argument :id, Integer, required: false
    argument :per_page, Integer, required: false, prepare: -> (per_page, ctx) { per_page || 50 }
    argument :page, Integer, required: false
  end

  def events args = {}
    if args[:id]
      Event.where(id: args[:id])
    else
      base = Event.all
      base = base.page(args[:page]).per(args[:per_page]) if args[:page] and args[:per_page]
      base
    end
  end
end
