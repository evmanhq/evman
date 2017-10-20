module EventServices
  module ExportRenderer
    class CSV < Base
      def content_type
        'application/csv'
      end

      def render
        require 'csv'

        csv_string = ::CSV.generate do |csv|
          csv << header
          records.each do |record|
            csv << record
          end
        end

        Result.new(csv_string, content_type, 'export.csv')
      end
    end
  end
end