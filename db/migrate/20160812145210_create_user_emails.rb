class CreateUserEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :user_emails do |t|
      t.references    :user
      t.string        :email
      t.boolean       :active, default: false
      t.timestamps
    end
  end
end
