class Types::TeamType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: false
  field :description, String, null: true
  field :active, Boolean, null: false
  field :subdomain, String, null: false
  field :email_domain, String, null: true
end