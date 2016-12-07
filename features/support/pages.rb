module Pages
  class Page
    include RSpec::Matchers
    include Capybara::DSL
    include Pages
    include DynamicSelect
    include WaitForAjax
  end

  def on page_class, &block
    page_object = page_class.new
    block.call(page_object)
  end
end