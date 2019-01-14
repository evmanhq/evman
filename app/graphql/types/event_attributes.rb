class Types::EventAttributes < Types::BaseInputObject
  description "Attributes for creating or updating an event"
  argument :approved, Boolean, required: false
  argument :committed, Boolean, required: false
end