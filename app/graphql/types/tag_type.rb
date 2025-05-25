class Types::TagType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :keyword, String, null: true

  [:begins_at, :created_at].each do |date_column|
    field date_column, GraphQL::Types::ISO8601DateTime, null: false
  end
end