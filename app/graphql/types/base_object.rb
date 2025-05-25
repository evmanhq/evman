class Types::BaseObject < GraphQL::Schema::Object
  include Authorization::ControllerHelpers

  def self.authorized?(object, context)
    return true unless object.is_a? ApplicationRecord
    super && Authorization.dictator.authorized?(object, :read)
  end

  def self.scope_items(items, context)
    items.select do |item|
      case item
      when ApplicationRecord
        Authorization.dictator.authorized?(item, :read)
      else
        true
      end
    end
  end

  def current_user
    context[:current_user]
  end

  def current_team
    context[:current_team]
  end
end
