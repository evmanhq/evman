module EvmanMenu
  class Menu
    include Configurable
    attr_reader :items
    def initialize &block
      @items = []

      configure &block
    end

    def add_item item
      items << item
    end

    def page *options, &block
      page = Page.new(*options)
      page.configure &block
      add_item page
    end

    def section *options, &block
      section = Section.new(*options)
      section.configure &block
      add_item section
    end

    def to_partial_path
      'evman_menu/menu'
    end
  end
end