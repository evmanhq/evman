module Pages
  module Events
    class ExpensesPage < Page
      DEFAULT_DATA = {
          price: 9.99
      }

      def new_expense_button
        find '.new-expense-button'
      end

      def expenses_container
        find '.expenses-container'
      end

      def submit_form data = {}
        data = DEFAULT_DATA.merge(data)
        fill_dynamic_select 'expense[expense_type_id]', with: data[:expense_type_id]
        fill_in 'expense[usd]', with: data[:price]
        click_on('Save')
        wait_for_ajax
      end
    end
  end
end