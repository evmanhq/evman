class Types::TalkType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :abstract, String, null: true
  field :archived, Boolean, null: false

  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end

  field :events, [Types::EventType], null: false, preload: { events: :teams }
  field :event_talks, [Types::EventTalkType], null: false, preload: :event_talks
  field :event_type, Types::EventTypeType, null: false, preload: :event_type
end
