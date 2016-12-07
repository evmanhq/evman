class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.jsonb :authorization_profile
      t.belongs_to :team
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
