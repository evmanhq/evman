module TagServices
  class PopulateForm
    include ActiveModel::Model

    def model_name
      ActiveModel::Name.new(self, nil, "PopulateForm")
    end

    attr_accessor :tag_names, :team

    def initialize params, team
      @tag_names = params[:tag_names]
      @team = team
    end

    def submit
      Tag.transaction do
        tag_names.each do |tag_name|
          team.tags.create(name: tag_name) if team.tags.where(keyword: tag_name.downcase).none?
        end
      end
    end
  end
end