class CreateTeamInvitations < ActiveRecord::Migration
  def change
    create_table :team_invitations do |t|
      t.string      :email
      t.string      :code, :null => false, :unique => true
      t.references  :user
      t.references  :team
      t.boolean     :accepted, :null => true, :default => nil

      t.timestamps null: false
    end
  end
end
