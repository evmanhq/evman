class CitiesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        @cities = City
        if params[:q] && params[:q][:term]
          @cities = @cities.fulltext_search(params[:q][:term])
        end
        @cities = @cities.limit(500)
        render :json => @cities.all.map { |item| {:id => item.id, :name => item.display} }
      end
    end
  end

  def show
    @city = City.find(params[:id])
    render json: { id: @city.id, name: @city.display }
  end

end
