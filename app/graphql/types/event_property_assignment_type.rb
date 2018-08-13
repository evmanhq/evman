class Types::EventPropertyAssignmentType < Types::BaseObject
  field :label, String, null: false
  field :behaviour, String, null: false
  field :values, [String], null: false
end
