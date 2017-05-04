class Form < ApplicationRecord
  belongs_to :team
  has_many :submissions, class_name: 'FormSubmission'

  validates :name, presence: true, uniqueness: true

  after_validation :validate_fields

  def validate_fields
    return true unless data['fields']
    data['fields'].each do |field|
      errors.add :base, 'Label must be specified in each field' if field['label'].blank?
      errors.add :base, 'Type must be specified in each field' if field['type'].blank?

      field['required'] = field['required'] == 'on'
    end
  end
  
end
