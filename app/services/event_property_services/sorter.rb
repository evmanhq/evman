module EventPropertyServices
  class Sorter
    attr_reader :sorted_ids

    def initialize(sorted_ids)
      @sorted_ids = sorted_ids
    end

    def perform
      EventProperty.transaction do
        i = 1;
        sorted_ids.each do |id|
          property = EventProperty.find(id) rescue next
          property.position = i
          property.save!

          i += 1
        end

        # If there are some properties that are not specified in the sorted_ids array, add them at the end
        EventProperty.where.not(id: sorted_ids).each do |property|
          property.position = i
          property.save!

          i += 1
        end
      end
    end
  end
end