class CreateBiographies < ActiveRecord::Migration[5.0]
  def up
    create_table :biographies do |t|
      t.integer :user_id
      t.string :name
      t.text :content

      t.timestamps
    end
    add_reference :users, :default_biography
  end

  def down
    remove_reference :users, :default_biography
    drop_table :biographies
  end
end
