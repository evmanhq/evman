class CreateTaggeds < ActiveRecord::Migration[5.0]
  def change
    create_table :taggeds do |t|
      t.references  :item, :polymorphic => true
      t.references  :tag
      t.timestamps null: false
    end
  end
end
