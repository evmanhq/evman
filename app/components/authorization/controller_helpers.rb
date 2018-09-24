module Authorization
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      delegate :authorize!, :authorized?, to: :dictator
      delegate :can?, :can!,              to: :dictator
      helper_method :dictator if respond_to? :helper_method
    end

    def dictator
      Authorization.dictator
    end
  end
end