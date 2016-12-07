module OrganizedEventServices
  class PapersFilterer < ApplicationServices::Filterer
    def dispatch_filter filter
      return if filter.applied?
      case filter.name
      when :title then filter_title filter
      else
        nil
      end
    end

    private
    def filter_title filter
      delete_filter filter if filter.value.empty?
      operator = (%w[= ~] & [filter.operator]).first || '~'
      val = case operator
            when '~' then "%#{filter.value}%"
            else
              filter.value
            end

      case operator
      when '~' then @scope = @scope.where('title ILIKE ?', val)
      else
        @scope = @scope.where(title: val)
      end

    end
  end
end