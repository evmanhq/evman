class CreateFilterBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :filter_bookmarks do |t|
      t.string :code, limit: 36
      t.string :name
      t.string :filterer_name
      t.boolean :public
      t.belongs_to :team
      t.belongs_to :owner
      t.jsonb :payload

      t.timestamps

      t.index :code, unique: true
    end
  end
end
