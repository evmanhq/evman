class Types::QueryType < Types::BaseObject
  field :events, [Types::EventType], null: false, description: "List all events" do
    argument :id, Integer, required: false
    argument :ids, [Integer], required: false
    argument :per_page, Integer, required: false, prepare: -> (per_page, ctx) { per_page || 50 }
    argument :page, Integer, required: false
  end

  def events args = {}
    events = []
    events = Event.where(id: args[:id]) if args[:id]
    events = Event.where(id: args[:ids]) if args[:ids]

    events = current_team.events if events.empty?
    events = events.page(args[:page]).per(args[:per_page]) if args[:page] and args[:per_page]
    events = events.includes(:teams) # for authorization N+1 speedup
    events.select{|e| authorized? e, :read }
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
