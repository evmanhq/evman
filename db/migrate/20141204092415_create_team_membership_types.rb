class CreateTeamMembershipTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :team_membership_types do |t|
      t.string :name

      t.boolean :active

      t.timestamps
    end
  end
end
