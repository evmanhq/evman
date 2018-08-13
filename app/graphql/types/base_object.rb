class Types::BaseObject < GraphQL::Schema::Object
  def current_user
    context[:current_user]
  end

  def current_team
    context[:current_team]
  end
end
