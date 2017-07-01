class CreateExpenses < ActiveRecord::Migration[5.0]
  def change
    create_table :expenses do |t|
      t.references    :event
      t.references    :user
      t.references    :expense_type

      t.string        :report_id

      t.float         :amount
      t.references    :currency
      t.float         :rate

      t.float         :usd

      t.timestamps    null: false
    end
  end
end
