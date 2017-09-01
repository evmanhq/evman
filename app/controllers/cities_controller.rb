class CitiesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        @cities = City
        if params[:q] && params[:q][:term]
          @cities = @cities.fulltext_search(params[:q][:term])
        end
        render :json => @cities.all.map { |item| {:id => item.id, :name => item.display} }
      end
    end
  end

end
