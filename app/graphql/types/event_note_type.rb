class Types::EventNoteType < Types::BaseObject
  field :id, Integer, null: false
  field :content, String, null: false
  field :user, Types::UserType, null: false, preload: { user: :teams }
  field :event, Types::EventType, null: false, preload: :event

  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
end
