class Types::UserType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :email, String, null: false
  field :teams, [Types::TeamType], null: false, preload: :teams
  field :talks, [Types::TalkType], null: false, preload: { talks: :team }
  field :event_talks, [Types::EventTalkType], null: false, preload: :event_talks
  field :events, [Types::EventType], null: false, preload: { events: :teams }
end
