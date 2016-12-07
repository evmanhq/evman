When(/^I submit add expense form$/) do
  @expense_price = 99.99
  @expense_type = current_team.expense_types.first
  on(Pages::Events::ExpensesPage) do |po|
    po.new_expense_button.click
    wait_for_ajax
    po.submit_form price: @expense_price, expense_type_id: @expense_type.id
  end
end

Then(/^I should see a new expense$/) do
  on(Pages::Events::ExpensesPage) do |po|
    expect(po.expenses_container).to have_content @expense_type.name
    expect(po.expenses_container).to have_content @expense_price
  end
end

When(/^I submit add warehouse item form$/) do
  warehouse = FactoryGirl.create :warehouse, teams: [current_team]
  item = FactoryGirl.create :warehouse_item, warehouse: warehouse
  batch = FactoryGirl.create :warehouse_batch, item: item
  on(Pages::Events::WarehouseTransactionsPage) do |po|
    po.new_warehouse_transaction_button.click
    wait_for_ajax
    po.submit_form warehouse_item_name: item.name
  end
  @warehouse_item = item
end

Then(/^I should see a new warehouse item transaction in event$/) do
  on(Pages::Events::WarehouseTransactionsPage) do |po|
    expect(po.warehouse_transactions_container).to have_content @warehouse_item.name
  end
end