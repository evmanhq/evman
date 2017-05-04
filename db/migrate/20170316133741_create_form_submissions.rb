class CreateFormSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :form_submissions do |t|
      t.belongs_to :submitted_by
      t.belongs_to :form
      t.jsonb      :data

      t.integer    :associated_object_id
      t.string     :associated_object_type

      t.timestamps
    end

    add_index :form_submissions, [:associated_object_type, :associated_object_id], name: 'asociated_object_index'
  end
end
