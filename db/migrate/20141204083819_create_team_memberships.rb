class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships do |t|
      t.references :user
      t.references :team
      t.references :team_membership_type

      t.boolean :active

      t.timestamps
    end

    add_index :team_memberships, :team_id
    add_index :team_memberships, :user_id
    add_index :team_memberships, :team_membership_type_id

  end
end
