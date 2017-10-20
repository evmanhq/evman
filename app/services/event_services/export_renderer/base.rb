module EventServices
  module ExportRenderer
    class Base
      attr_reader :header, :records, :options
      def initialize(header, records, options={})
        @header = header
        @records = records
        @options = options
      end

      def render
        raise StandardError, 'should be implemented in subclass'
      end
    end

    Result = Struct.new(:data, :content_type, :filename)
  end
end