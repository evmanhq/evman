module EvmanMenu
  class Item
    include Configurable
    attr_reader :items, :captures
    attr_reader :name, :path, :icon, :modal
    def initialize name:, icon:, path: nil, modal: nil
      @name, @path, @icon, @modal = name, path, icon, modal
      @items = []
      @captures = []
      add_capture Capture.new(path) if path.present?
    end

    def add_item item
      items << item
    end

    def add_capture capture
      captures << capture
    end

    def capture data
      add_capture Capture.new(data)
    end

    def active? request
      captures.any?{ |c| c.captures? request }
    end
  end
end