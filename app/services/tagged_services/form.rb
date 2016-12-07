module TaggedServices
  class Form
    include ActiveModel::Model

    attr_accessor :item

    delegate :tags, to: :item

    def model_name
      ActiveModel::Name.new(self, nil, "TaggedsForm")
    end

    def initialize item, params={}
      @item = item
      @params = params

      raise ArgumentError, "#{item.class} does not repond to `tags`" unless item.respond_to? :tags
      raise ArgumentError, "#{item.class} does not repond to `team`" unless item.respond_to? :team
    end

    def submit
      return false if invalid?

      existing_tag_names = tags.pluck(:name)
      tag_names_to_add = tag_names - existing_tag_names
      tag_names_to_delete = existing_tag_names - tag_names

      Tag.transaction do
        add_tags tag_names_to_add
        remove_tags tag_names_to_delete
      end
      true
    end

    def persisted?
      false
    end

    def tag_names
      (@params[:tag_names] || tags.pluck(:name)).reject(&:blank?)
    end

    private

    def add_tags tag_names
      existing_tags = Tag.where(keyword: tag_names.collect(&:downcase), team: item.team)
      item.tags << existing_tags

      new_tag_names = tag_names - existing_tags.collect(&:name)
      new_tag_names.each do |tag_name|
        tag = Tag.create!(name: tag_name, team: item.team)
        item.tags << tag
      end
    end

    def remove_tags tag_names
      tags = Tag.where(keyword: tag_names.collect(&:downcase))
      item.tags.destroy(tags)
    end
  end
end