module FormServices
  class FormSubmissionForm
    include ActiveModel::Model

    def model_name
      ActiveModel::Name.new(self, nil, "FormSubmissionForm")
    end

    delegate :persisted, :form_id, :associated_object_id, :associated_object_type, to: :submission
    attr_reader :submission, :form, :params, :current_user

    validate do |form|
      fields = form.fields
      fields.each do |field|
        field.validate
        form.errors.add :base, :question_blank, question: field.label unless field.valid?
      end

      submission = form.submission

      form.errors.add :base, :form_structure_changed if submission.form_structure_changed?

      submission.valid?
      submission.errors.full_messages.each do |message|
        form.errors.add :base, message
      end
    end

    def initialize submission, current_user = nil, params={}
      @submission, @current_user = submission, current_user
      @form = submission.form
      @params = params || {}
    end

    def fields
      @fields ||= form.data['fields'].collect do |f|
        Field.new(f, submission, params)
      end
    end

    def serialize_fields
      fields.collect do |field|
        {
            id:    field.id,
            value: field.value,
            label: field.label,
            type:  field.type
        }
      end
    end

    def title
      @form.name
    end

    def submit
      submission.data = serialize_fields
      submission.submitted_by = current_user
      submission.form_structure_hash = form.structure_hash if submission.new_record?

      return false if invalid?

      submission.save
    end

    def to_model
      submission
    end

    class Field

      attr_reader :definition, :value, :submission
      def initialize definition, submission, params
        @submission = submission
        @definition = definition
        @value = (params[name] || {})['value']
        @value ||= submission_value(id)
        @value.reject!(&:blank?) if @value.is_a? Array
        @valid = true
      end

      def name
        "field_#{id}"
      end

      def id
        definition['id']
      end

      def type
        definition['type'] || 'text'
      end

      def label
        definition['label']
      end

      def choices
        return [] unless definition['choices']
        return [] if definition['choices'].empty?
        @choices||= definition['choices'].map{|choice| Choice.new(choice) }
      end

      def required?
        definition['required']
      end

      def edit_partial_path
        "forms/fields/edit/#{type.underscore}"
      end

      def validate
        return true unless required?
        @valid = false if value.blank?
      end

      def valid?
        @valid
      end

      private
      def submission_value(id)
        return nil unless submission.data
        field = submission.data.find{ |f| f['id'] == id }
        return nil unless field
        field['value']
      end
    end

    Choice = Struct.new(:name)

  end
end