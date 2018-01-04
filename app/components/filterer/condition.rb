module Filterer
  class Condition
    attr_reader :name

    def initialize(name, filterer)
      @name     = name
      @filterer = filterer
    end

    def label
      defaults = [
          :"filterer.#{@filterer.i18n_name}.conditions.#{name}",
          :"filterer.base.conditions.#{name}",
          name
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def as_json(options={})
      {
          label: label,
          name:  name
      }
    end
  end
end