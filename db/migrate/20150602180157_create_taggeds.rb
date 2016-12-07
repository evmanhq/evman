class CreateTaggeds < ActiveRecord::Migration
  def change
    create_table :taggeds do |t|
      t.references  :item, :polymorphic => true
      t.references  :tag
      t.timestamps null: false
    end
  end
end
