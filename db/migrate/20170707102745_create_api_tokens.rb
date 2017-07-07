class CreateApiTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :api_tokens do |t|
      t.string      :name, null: false
      t.string      :token, null: false, unique: true
      t.references  :team, null: true
      t.references  :user, null: true
      t.boolean     :global, default: false
      t.timestamps
    end
  end
end
