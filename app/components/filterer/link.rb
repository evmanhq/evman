module Filterer
  class Link
    attr_reader :name, :icon
    def initialize(name: nil, label: nil, icon: nil, filterer_class: nil, &block)
      raise ArgumentError, 'filterer_class' unless filterer_class
      @name = name
      @label = label
      @icon = icon
      @filterer_class = filterer_class
      @block = block
      @helpers = Rails.application.routes.url_helpers
    end

    def label
      return @label if @label
      defaults = [
          :"filterer.#{@filterer_class.i18n_name}.links.#{name}",
          :"filterer.base.links.#{name}",
          name.capitalize
      ]
      I18n.translate(defaults.shift, default: defaults)
    end

    def path(filter_bookmark)
      @block.call(filter_bookmark, @helpers)
    end
  end
end