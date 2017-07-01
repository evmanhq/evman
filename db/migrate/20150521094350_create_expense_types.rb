class CreateExpenseTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :expense_types do |t|
      t.string      :name
      t.references  :team
      t.boolean     :default
      t.timestamps null: false
    end
  end
end
