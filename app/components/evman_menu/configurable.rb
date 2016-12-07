module EvmanMenu
  module Configurable
    def configure &block
      if block.present?
        if block.arity == 1
          block.call(self)
        else
          instance_eval &block
        end
      end
    end
  end
end