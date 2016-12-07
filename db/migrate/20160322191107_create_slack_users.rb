class CreateSlackUsers < ActiveRecord::Migration
  def change
    create_table :slack_users do |t|
      t.references  :user
      t.references  :slack_setting
      t.string      :username
      t.timestamps  null: false
    end
  end
end
