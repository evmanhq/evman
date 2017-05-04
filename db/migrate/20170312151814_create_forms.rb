class CreateForms < ActiveRecord::Migration[5.0]
  def change
    create_table :forms do |t|
      t.string :name
      t.string :description
      t.boolean :published, default: false
      t.belongs_to :team
      t.jsonb :data

      t.timestamps
    end
  end
end
