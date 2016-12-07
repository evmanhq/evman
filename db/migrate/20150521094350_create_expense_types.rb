class CreateExpenseTypes < ActiveRecord::Migration
  def change
    create_table :expense_types do |t|
      t.string      :name
      t.references  :team
      t.boolean     :default
      t.timestamps null: false
    end
  end
end
