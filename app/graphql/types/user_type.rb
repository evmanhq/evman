class Types::UserType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :email, String, null: false
  field :teams, [Types::TeamType], null: false, preload: :teams
end
