class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|

      t.string :name
      t.text :description

      t.string  :email_domain
      t.boolean :active

      t.string  :subdomain, :unique => true, :null => false
      t.timestamps
    end
  end
end
