module Filterer
  class SortRuleField
    TYPES = %w[text number multiple_choice date]

    attr_reader :name
    def initialize(name: nil, label: nil, filterer: nil)
      @name = name
      @label = label
      @filterer = filterer
    end

    def label
      return @label if @label
      defaults = [
          :"filterer.#{@filterer.i18n_name}.sort_rule_fields.#{name}",
          :"filterer.base.sort_rule_fields.#{name}",
          name.capitalize
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def as_json(opts={})
      {
          label: label,
          name: name
      }
    end
  end
end