class Types::TalkType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :abstract, String, null: true
  field :archived, Boolean, null: false

  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
end