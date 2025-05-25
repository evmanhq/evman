require 'graphql/batch'
require "graphql/types/iso_8601_date_time"

### graphql-preload patch vor graphql v 1.8
# https://github.com/ConsultingMD/graphql-preload/pull/11
GraphQL::Preload::Instrument.class_eval do
  def instrument(_type, field)
    return field unless field.metadata.include?(:preload)

    old_resolver = field.resolve_proc
    new_resolver = ->(obj, args, ctx) do
      return old_resolver.call(obj, args, ctx) unless obj

      if field.metadata[:preload_scope]
        scope = field.metadata[:preload_scope].call(args, ctx)
      end

      # FIX: Change from `obj` to `obj.object`
      preload(obj.object, field.metadata[:preload], scope).then do
        old_resolver.call(obj, args, ctx)
      end
    end

    field.redefine do
      resolve(new_resolver)
    end
  end
end

GraphQL::Schema.accepts_definition :enable_preloading
GraphQL::Schema::Field.accepts_definition :preload
GraphQL::Schema::Field.accepts_definition :preload_scope

### graphql-preload patch vor graphql v 1.8 END

class EvmanSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
  use GraphQL::Batch

  instrument(:field, GraphQL::Preload::Instrument.new)
  # enable_preloading
  #

  def self.unauthorized_object(error)
    return nil
  end
end
