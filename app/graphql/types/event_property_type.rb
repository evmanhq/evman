class Types::EventPropertyType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :position, Integer, null: false
  field :behaviour, String, null: false
  field :required, Boolean, null: false

  field :team, Types::TeamType, null: false, preload: :team
  field :options, [Types::EventPropertyOptionType], null: false, preload: :options
end
