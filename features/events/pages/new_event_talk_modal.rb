module Pages
  module Events
    class NewEventTalkModal < Page
      def submit_form data = {}
        fill_dynamic_select 'event_talk[user_id]', with: data[:user_id]
        fill_dynamic_select 'event_talk[event_id]', with: data[:event_id]
        select2 'event_talk[talk_id]', search: data[:talk_name]
        click_on('Save')
        wait_for_ajax
      end
    end
  end
end