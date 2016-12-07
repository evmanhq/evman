module Authorization
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      delegate :authorize!, :authorized?, to: :dictator
      delegate :can?, :can!,              to: :dictator
      helper_method :dictator
    end

    def dictator
      Authorization.dictator
    end
  end
end