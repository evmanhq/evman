class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table(:users) do |t|
      t.string      :name,  :null => true
      t.string      :email, :null => true

      t.string      :token, :null => true, :default => nil
      t.string      :password_digest, :null => true, :default => nil

      t.references  :home_country
      t.string      :job_title

      t.string      :organization
      t.string      :phone
      t.string      :twitter
      t.string      :github

      t.timestamps
    end

    add_index :users, :email, unique: true

  end
end
