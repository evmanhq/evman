module Pages
  module Events
    class ShowPage < Page
      def map_link
        first('.map-trigger')
      end

      def committed_button
        first 'a', text: 'Committed'
      end

      def approved_button
        first 'a', text: 'Approved'
      end

      def archived_button
        first 'a', text: 'Archived'
      end

      def expect_button_status button, condition
        if condition
          expect(button).to have_css '.fa.fa-check'
        else
          expect(button).to have_css '.fa.fa-remove'
        end
      end

      def expect_to_be_archived
        expect(archived_button).not_to be_nil
      end

      def expect_not_to_be_archived
        expect(archived_button).to be_nil
      end

      # Notes

      def new_note_button
        first('.new-note-button')
      end

      def submit_new_note_form data = {}
        new_note_button.click
        on(NewNoteModal) do |po|
          po.submit_form data
        end
      end

      # Attendees

      def add_attendee_button
        first('.add-attendee-button')
      end

      def attendee_list_pannel
        first('.attendee-list')
      end

      def attendee_avatar user
        attendee_list_pannel.all('img').select{ |i| i[:alt] == user.name }.first
      end

      def submit_add_attendee_form data = {}
        add_attendee_button.click
        wait_for_ajax
        on(AddAttendeeModal) do |po|
          po.submit_form data
        end
      end
      
      # Talks

      def talks_container
        first('.event-talks-container')
      end

      def new_event_talk_button
        first('.new-event-talk-button')
      end

      def submit_new_event_talk_form data = {}
        new_event_talk_button.click
        wait_for_ajax
        on(NewEventTalkModal) do |po|
          po.submit_form data
        end
      end
    end
  end
end