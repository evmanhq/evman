class CreateAnnouncementUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :announcement_users do |t|
      t.references  :announcement
      t.references  :user
      t.string      :answer
      t.timestamps
    end
  end
end
