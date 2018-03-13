class CreateTeamEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :team_events do |t|
      t.references  :team
      t.references  :event
      t.timestamps
    end

    Event.all.each do |event|
      TeamEvent.create(team: event.team, event: event)
    end
  end
end
