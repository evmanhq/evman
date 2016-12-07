module Pages
  module Events
    class WarehouseTransactionsPage < Page
      DEFAULT_DATA = {
          count: 1,
          returned: 0
      }

      def new_warehouse_transaction_button
        find '.new-warehouse-transaction-button'
      end

      def warehouse_transactions_container
        find '.warehouse-transactions-container'
      end

      def submit_form data = {}
        data = DEFAULT_DATA.merge(data)
        select2 'warehouse_transaction[batch_id]', search: data[:warehouse_item_name]
        fill_in 'warehouse_transaction[count]', with: data[:count]
        fill_in 'warehouse_transaction[returned]', with: data[:returned]
        click_on('Save')
        wait_for_ajax
      end
    end
  end
end