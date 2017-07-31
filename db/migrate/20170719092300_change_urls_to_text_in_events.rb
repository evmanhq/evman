class ChangeUrlsToTextInEvents < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :url, :text
    change_column :events, :url2, :text
    change_column :events, :url3, :text
  end
end
