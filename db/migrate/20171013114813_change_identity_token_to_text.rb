class ChangeIdentityTokenToText < ActiveRecord::Migration[5.1]
  def change
    change_column :identities, :token, :text
  end
end
