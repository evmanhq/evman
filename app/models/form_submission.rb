class FormSubmission < ApplicationRecord
  belongs_to :form, inverse_of: :submissions
  belongs_to :submitted_by, class_name: 'User'
  belongs_to :associated_object, polymorphic: true

  ALLOWED_ASSOCIATED_OBJECTS = [Event]

  validate do |submission|
    case submission.associated_object
    when *ALLOWED_ASSOCIATED_OBJECTS
    else
      submission.errors.add :associated_object, :invalid
    end
  end

  def associated_object_name
    associated_object.name
  end

  def associated_object_path
    associated_object
  end

  def form_structure_changed?
    return true unless form
    form_structure_hash != form.structure_hash
  end

  def concerned_teams
    form.concerned_teams
  end

  def concerned_users
    [submitted_by]
  end

end