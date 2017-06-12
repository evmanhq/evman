class AddEventFeedbackFormToTeams < ActiveRecord::Migration[5.0]
  def change
    add_reference :teams, :event_feedback_form, index: true
  end
end
