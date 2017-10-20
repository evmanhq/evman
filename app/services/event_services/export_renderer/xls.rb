module EventServices
  module ExportRenderer
    class XLS < Base
      def sheet_name
        options[:sheet_name] || 'Events'
      end

      def content_type
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      end

      def render
        package = Axlsx::Package.new
        package.workbook.add_worksheet(name: sheet_name) do |sheet|
          sheet.add_row(header)

          records.each do |record|
            sheet.add_row(record)
          end
        end

        Result.new(package.to_stream.string, content_type, 'export.xlsx')
      end
    end
  end
end