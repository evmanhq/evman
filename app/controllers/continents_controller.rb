class ContinentsController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        @continents = Continent
        render :json => @continents.all.map { |item| {:id => item.id, :name => item.name} }
      end
    end
  end

end
