module DynamicSelect

  def select2 name, search: nil, wait_for_request: nil
    label = page.first("select[name='#{name}']")
    label_parent = label.find(:xpath, '..')
    select2_container = label_parent.find('.select2-container')
    select2_container.click

    select2_search_input = page.first('.select2-search__field')
    select2_search_input.set(search)

    sleep wait_for_request if wait_for_request.present?
    wait_for_ajax # wait if select2 uses ajax to load results

    select2_result_option = page.first('.select2-results__option')
    select2_result_option.click
  end

  def fill_dynamic_select name, with: nil
    # find("select[name=#{name}]").set(with)
    escaped = with.to_s.gsub(/'/,"\\\\'")
    execute_script <<-Javascript
      select = document.querySelector('select[name="#{name}"]');
      if(select == undefined) {
        throw "Unable to find synamic select with name: #{name}";
      }

      if(select.classList.contains('selectized')) {
        select.selectize.addItem('#{escaped}');
      } else if(select.classList.contains('select2-hidden-accessible')) {
        select.value = '#{escaped}';
      }
    Javascript
  end
end