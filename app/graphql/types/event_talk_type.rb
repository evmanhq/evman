class Types::EventTalkType < Types::BaseObject
  field :id, Integer, null: false
  field :talk, Types::TalkType, null: false, preload: :talk
  field :user, Types::UserType, null: false, preload: :user
  field :state, Boolean, null: false
  field :description, String, null: true

  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
end