Inputs::FiltererPayloadInput = GraphQL::InputObjectType.define do
  name 'FiltererPayloadInput'
  Constrain = GraphQL::InputObjectType.define do
    name 'Constrain'
    argument :name, !types.String
    argument :condition, !types.String
    argument :values, !types[types.String]
  end

  SortRule = GraphQL::InputObjectType.define do
    name 'SortRule'
    argument :name, !types.String
    argument :direction, !types.String
  end

  argument :constrains, types[Constrain]
  argument :sort_rules, types[SortRule]
end