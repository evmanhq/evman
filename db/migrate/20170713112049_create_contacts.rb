class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :job_title
      t.string :email
      t.string :phone_office
      t.string :phone_cell
      t.belongs_to :team

      t.timestamps
    end

    create_join_table :contacts, :events do |t|
      t.index :contact_id
      t.index :event_id
    end
  end
end
