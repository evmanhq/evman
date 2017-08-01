class AddBehaviourToEventProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :event_properties, :behaviour, :string, default: 'multiple_choice'
  end
end
