Inputs::FiltererPayloadConstrain = GraphQL::InputObjectType.define do
  name 'Constrain'
  argument :name, !types.String
  argument :condition, !types.String
  argument :values, !types[types.String]
end

Inputs::FiltererPayloadSortRule = GraphQL::InputObjectType.define do
  name 'SortRule'
  argument :name, !types.String
  argument :direction, !types.String
end

Inputs::FiltererPayloadInput = GraphQL::InputObjectType.define do
  name 'FiltererPayloadInput'

  argument :constrains, types[Inputs::FiltererPayloadConstrain]
  argument :sort_rules, types[Inputs::FiltererPayloadSortRule]
end