class BreadcrumbNav

  attr_reader :items
  delegate :empty?, :any?, :blank?, to: :items

  def initialize
    @items = []
  end

  def add_item label, url=nil
    items << Item.new(self, label, url)
    true
  end

  Item = Struct.new(:nav, :label, :url) do
    def last?
      nav.items.last == self
    end
  end

end