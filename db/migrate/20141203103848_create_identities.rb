class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|

      t.references  :user, index: true

      t.string      :provider
      t.string      :uid

      t.string      :token
      t.string      :secret
      t.datetime    :expires

      t.timestamps
    end
  end
end
