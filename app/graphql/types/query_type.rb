class Types::QueryType < Types::BaseObject
  DEFAULT_PER_PAGE = 50
  field :events, [Types::EventType], null: false, description: "List all team events" do
    argument :id, Integer, required: false
    argument :ids, [Integer], required: false
    argument :per_page, Integer, required: false, prepare: -> (per_page, ctx) { per_page || DEFAULT_PER_PAGE }
    argument :page, Integer, required: false
    argument :filterer_payload, Inputs::FiltererPayloadInput, required: false
  end

  def events args = {}
    events = Event.all
    events = Event.where(id: args[:id]) if args[:id]
    events = Event.where(id: args[:ids]) if args[:ids]

    if args[:filterer_payload]
      filterer = Filterer::EventsFilterer.new(scope: events, payload: args[:filterer_payload].to_h, current_team: current_team)
      events = filterer.filtered
    end

    events = events.page(args[:page]).per(args[:per_page]) if args[:page] and args[:per_page]
    events.includes(:teams) # for authorization N+1 speedup
  end

  field :talks, [Types::TalkType], null: false, description: "List all team talks" do
    argument :id, Integer, required: false
    argument :ids, [Integer], required: false
    argument :per_page, Integer, required: false, prepare: -> (per_page, ctx) { per_page || DEFAULT_PER_PAGE }
    argument :page, Integer, required: false
  end

  def talks args = {}
    talks = Talk.all
    talks = Talk.where(id: args[:id]) if args[:id]
    talks = Talk.where(id: args[:ids]) if args[:ids]
    talks = talks.page(args[:page]).per(args[:per_page]) if args[:page] and args[:per_page]
    talks.includes(:team) # for authorization N+1 speedup
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
