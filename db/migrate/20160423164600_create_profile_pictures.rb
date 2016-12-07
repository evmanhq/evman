class CreateProfilePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_pictures do |t|
      t.references :user
      t.boolean    :public, default: false
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        add_attachment :profile_pictures, :image
        add_reference :users, :default_profile_picture
      end

      dir.down do
        remove_attachment :profile_pictures, :image
        remove_reference :users, :default_profile_picture
      end
    end
  end
end
