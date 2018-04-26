class CreateAnnouncements < ActiveRecord::Migration[5.1]
  def change
    create_table :announcements do |t|
      t.string      :heading
      t.text        :content
      t.references  :team
      t.json        :answer
      t.timestamps
    end
  end
end
