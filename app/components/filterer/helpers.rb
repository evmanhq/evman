module Filterer
  module Helpers
    def perform_filter_text(column, values, condition)
      value = values.first

      case condition
      when 'like' then
        @scope = @scope.where("#{column} ILIKE ?", "%#{value}%")
      when 'not_like' then
        @scope = @scope.where("#{column} NOT ILIKE ?", "%#{value}%")
      when 'begins' then
        @scope = @scope.where("#{column} ILIKE ?", "#{value}%")
      when 'equals' then
        @scope = @scope.where("#{column} = ?", value)
      end
    end

    def perform_filter_date(column, values, condition)
      value = values[0]
      return if value.blank?
      case condition
      when 'before'
        @scope = @scope.where("#{column} <= ?", value)
      when 'after'
        @scope = @scope.where("#{column} >= ?", value)
      when 'at'
        @scope = @scope.where("#{column} = ?", value)
      when 'range'
        from, to = value.split(/\s*to\s*/)
        @scope = @scope.where("#{column} BETWEEN ? AND ?", from, to)
      end

    end

    def perform_filter_boolean(column, values, condition)
      values = values.map do |value|
        case value
        when 'true', 'yes'
          true
        when 'false', 'no'
          false
        when 'nil'
          nil
        end
      end

      case condition
      when 'any' then
        @scope = @scope.where(column => values)
      when 'none' then
        @scope = @scope.where.not(column => values)
      end
    end
  end
end