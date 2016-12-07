class CreateSlackSettings < ActiveRecord::Migration
  def change
    create_table :slack_settings do |t|
      t.references  :team

      t.string      :access_token
      t.string      :scope

      t.string      :team_name
      t.string      :team_uid

      t.string      :hook_channel
      t.string      :hook_channel_id
      t.string      :hook_configuration
      t.string      :hook_url

      t.string      :bot_id
      t.string      :bot_token

      t.timestamps  null: false
    end
  end
end
