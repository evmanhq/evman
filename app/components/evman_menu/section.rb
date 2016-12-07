module EvmanMenu
  class Section < Item
    def active? request
      super(request) or items.any?{|i| i.active? request }
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
      'evman_menu/menu_section'
    end
  end
end