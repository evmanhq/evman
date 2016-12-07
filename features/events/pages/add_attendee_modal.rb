module Pages
  module Events
    class AddAttendeeModal < Page
      def submit_form data = {}
        fill_dynamic_select 'attendee[user_id]', with: data[:user_id]
        click_on('Save')
        wait_for_ajax
      end
    end
  end
end