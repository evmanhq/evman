class Types::EventPropertyAssignmentType < Types::BaseObject
  field :id, Integer, null: false
  field :label, String, null: false
  field :behaviour, String, null: false
  field :values, [EventPropertyAssignmentValueType], null: false
end
