class CreateTeamMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_memberships do |t|
      t.references :user
      t.references :team
      t.references :team_membership_type

      t.boolean :active

      t.timestamps
    end

  end
end
