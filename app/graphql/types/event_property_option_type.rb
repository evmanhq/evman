class Types::EventPropertyOptionType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :property, Types::EventPropertyType, null: false, preload: :property
end
