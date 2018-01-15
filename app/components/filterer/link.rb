module Filterer
  class Link
    attr_reader :name, :icon
    def initialize(name: nil, label: nil, icon: nil, filterer_class: nil, &path_definitions)
      raise ArgumentError, 'filterer_class' unless filterer_class
      raise ArgumentError, 'block is required' unless block_given?
      @name = name
      @label = label
      @icon = icon
      @filterer_class = filterer_class
      @path_definitions = path_definitions
      @helpers = Rails.application.routes.url_helpers

      validate_path_definitions!
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

    def paths(filter_bookmark)
      PathManager.new(filter_bookmark, &@path_definitions)
    end

    private

    def validate_path_definitions!
      filter_bookmark = FilterBookmark.new(code: SecureRandom.uuid)
      paths = PathManager.new(filter_bookmark, &@path_definitions)
      raise ArgumentError, 'at least one link path is required' if paths.private_path.blank?
    end

    class PathManager
      include Rails.application.routes.url_helpers

      def initialize(filter_bookmark, &block)
        instance_exec(filter_bookmark, &block)
      end

      def public_path
        @public_path || @private_path
      end

      def private_path
        @private_path || @public_path
      end

      def public_link(link)
        @public_path = link
      end

      def private_link(link)
        @private_path= link
      end
    end
  end
end