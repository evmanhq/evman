class AddFormStructureHashToFormSubmissions < ActiveRecord::Migration[5.0]
  def change
    add_column :form_submissions, :form_structure_hash, :string, limit: 32
  end
end
