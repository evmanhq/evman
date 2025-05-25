class Types::AttributeErrorType < Types::BaseObject
  field :name, String, null: false
  field :messages, [String], null: false
end

