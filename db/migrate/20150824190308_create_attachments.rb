class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string      :name
      t.attachment  :file
      t.references  :user
      t.references  :parent, :polymorphic => true
      t.timestamps null: false
    end
  end
end
