class Types::EventTalkType < Types::BaseObject
  field :id, Integer, null: false
  field :talk, Types::TalkType, null: false, preload: { talk: :team }
  field :event, Types::EventType, null: false, preload: { event: :team }
  field :user, Types::UserType, null: false, preload: { user: :teams }
  field :state, Boolean, null: true
  field :description, String, null: true

  [:created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
end
