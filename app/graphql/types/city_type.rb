class Types::CityType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: true, preload: :english_city_name
end