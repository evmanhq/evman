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
        @scope = @scope.where(name: value)
      end
    end
  end
end