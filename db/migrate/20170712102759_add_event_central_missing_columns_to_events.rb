class AddEventCentralMissingColumnsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :description, :text
    add_column :events, :url2, :string
    add_column :events, :url3, :string
  end
end
