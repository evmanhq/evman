module Authorization
  module ModelHelpers
    extend ActiveSupport::Concern

    included do
      delegate :authorize!, :authorized?, to: :dictator
      delegate :can?, :can!,              to: :dictator
    end

    def dictator
      Authorization.dictator
    end

    class_methods do
      def dictator
        Authorization.dictator
      end

      def authorize_values_for property, options={}
        if defined?(AssignableValues)
          through_proc = proc {
            if dictator.active?
              dictator.policy_for(self)
            else
              nil
            end
          }
          assignable_values_for property, options.merge(:through => through_proc)
        else
          raise "To use .authorize_values_for, add the gem 'assignable_values' to your Gemfile"
        end
      end
    end
  end
end