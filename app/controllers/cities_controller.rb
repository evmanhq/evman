class CitiesController < ApplicationController

  def index

    cities = City.all

    cities = cities.fulltext_search(params[:fulltext]) if params[:fulltext]
    cities = cities.where(id: params[:ids]) if params[:ids]

    cities = cities.limit(500)
    json = cities.all.map do |item|
      {
          id: item.id,
          value: item.id.to_s,
          name: item.display,
          label: item.display
      }
    end

    render json: json
  end
end
