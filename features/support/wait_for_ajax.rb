module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    return false unless page.evaluate_script('jQuery.active').zero?
    if page.evaluate_script('Turbolinks.controller.currentVisit')
      return page.evaluate_script('Turbolinks.controller.currentVisit.state') == 'completed'
    end
    true
  end
end