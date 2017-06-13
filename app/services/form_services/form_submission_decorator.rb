module FormServices
  class FormSubmissionDecorator
    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def fields
      @fields ||= submission.data.collect do |f|
        Field.new(f)
      end
    end

    def title
      submission.form.name
    end

    class Field
      attr_reader :label, :value, :type
      def initialize(data)
        @label, @value, @type = data.values_at('label', 'value', 'type')
      end

      def to_partial_path
        "forms/fields/show/#{type.underscore}"
      end
    end
  end
end