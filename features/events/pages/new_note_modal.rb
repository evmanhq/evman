module Pages
  module Events
    class NewNoteModal < Page
      DEFAULT_DATA = {
          content: 'This is note content'
      }

      def content_field
        find '#event_note_content'
      end

      def submit_form data = {}
        data = DEFAULT_DATA.merge(data)
        content_field.set data[:content]
        click_on('Save')
      end
    end
  end
end