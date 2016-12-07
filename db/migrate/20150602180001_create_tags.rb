class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string      :name
      t.string      :keyword
      t.references  :team
      t.timestamps null: false
    end
  end
end
