module Authorization
  module Policies
    # == Policies::Base
    # Policy is decision point about some action that is about to be made on a model (not necessarily ApplicationRecord)
    # It uses information about the object itself and the authorization context stored in Dictator object
    class Base

      def self.model_class_name
        self.name.split('::').last.gsub(/Policy/,'')
      end

      def self.assignable_attribute attr, &block
        model = model_class_name.underscore
        define_method "assignable_#{model}_#{attr.to_s.pluralize}", &block
      end

      attr_reader :model, :dictator
      def initialize model, dictator
        @model, @dictator = model, dictator
      end

      # If appropriate method is not found, true is returned - allow by default
      def authorize *args
        action = args.shift
        action = "#{action}?" if respond_to? "#{action}?"
        return true unless respond_to? action
        the_method = method(action)
        if the_method.arity < args.size and the_method.arity != -1
          raise ArgumentError, "#{self.class}##{action} wrong number of arguments. Expected #{the_method.arity} received: #{args.size}"
        end
        send(action, *args)
      end
    end
  end
end