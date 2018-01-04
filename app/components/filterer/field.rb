module Filterer
  class Field
    TYPES = %w[text number multiple_choice date]

    attr_reader :name, :conditions, :type, :options, :options_url
    def initialize(name: nil, label: nil, conditions: [], type: nil, options: [], options_url: nil, filterer: nil)
      @name = name
      @label = label
      @filterer = filterer
      @conditions = build_conditions(conditions) if conditions.present?
      @type = type
      @options = options
      @options_url = options_url
    end

    def label
      return @label if @label
      defaults = [
          :"filterer.#{@filterer.i18n_name}.fields.#{name}",
          :"filterer.base.fields.#{name}",
          name.capitalize
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def as_json(opts={})
      json = {
          label: label,
          name: name,
          type: type,
          conditions: conditions.as_json
      }

      json[:options] = options if options.any?
      json[:options_url] = options_url if options_url.present?
      json
    end

    private
    def build_conditions(conditions)
      conditions.collect do |condition_definition|
        Condition.new(condition_definition, @filterer)
      end
    end
  end
end