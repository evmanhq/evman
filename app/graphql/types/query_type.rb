class Types::QueryType < Types::BaseObject
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

  field :me, Types::UserType, null: false
  def me
    current_user
  end

  field :team, Types::TeamType, null: false
  def team
    current_team
  end
end
