class Types::MutationType < Types::BaseObject
  field :update_event, mutation: Mutations::Events::Update
end
