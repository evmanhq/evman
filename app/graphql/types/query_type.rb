class Types::QueryType < Types::BaseObject
  DEFAULT_PER_PAGE = 50
  DEFAULT_PAGE = 1
  field :events, [Types::EventType], null: false, description: "List all team events" do
    argument :id, Integer, required: false
    argument :ids, [Integer], required: false
    argument :per_page, Integer, required: false, default_value: DEFAULT_PER_PAGE
    argument :page, Integer, required: false, default_value: DEFAULT_PAGE
    argument :filterer_payload, Inputs::FiltererPayloadInput, required: false
    argument :scopes, [String], required: false
    argument :only_current_team, Boolean, required: false
  end

  def events args = {}
    events = Event.all
    events = Event.where(id: args[:id]) if args[:id]
    events = Event.where(id: args[:ids]) if args[:ids]

    if args[:filterer_payload]
      filterer = Filterer::EventsFilterer.new(scope: events, payload: args[:filterer_payload].to_h, current_team: current_team)
      events = filterer.filtered
    end

    if args[:scopes]
      allowed_scopes = args[:scopes].map(&:to_sym) & Event.scopes
      allowed_scopes.each do |scope|
        events = events.public_send(scope)
      end
    end

    events = events.merge(current_team.events) if args[:only_current_team]

    events = events.page(args[:page]).per(args[:per_page]) if args[:page] and args[:per_page]
    events.includes(:teams) # for authorization N+1 speedup
  end

  field :talks, [Types::TalkType], null: false, description: "List all team talks" do
    argument :id, Integer, required: false
    argument :ids, [Integer], required: false
    argument :per_page, Integer, required: false, default_value: DEFAULT_PER_PAGE
    argument :page, Integer, required: false, default_value: DEFAULT_PAGE
    argument :scopes, [String], required: false
    argument :only_current_team, Boolean, required: false
    argument :user_id, Integer, required: false
  end

  def talks args = {}
    talks = Talk.order(created_at: :desc)
    talks = Talk.where(id: args[:id]) if args[:id]
    talks = Talk.where(id: args[:ids]) if args[:ids]

    if args[:scopes]
      allowed_scopes = args[:scopes].map(&:to_sym) & Event.scopes
      allowed_scopes.each do |scope|
        events = events.public_send(scope)
      end
    end

    talks = talks.where(user_id: args[:user_id]) if args[:user_id]

    talks = talks.merge(current_team.talks) if args[:only_current_team]

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
