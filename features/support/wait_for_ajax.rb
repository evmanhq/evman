module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    return false unless page.evaluate_script('jQuery.active').zero?
    if page.evaluate_script('typeof Turbolinks.controller.currentVisit') == 'object'
      state = page.evaluate_script('Turbolinks.controller.currentVisit.state')
      case state
      when 'completed'
        return true
      when 'failed'
        raise StandardError, 'Turbolinks visit failed'
      else
        return false
      end
    end
    true
  end
end