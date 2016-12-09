class CountriesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        @countries = Country
        if params[:q] && params[:q][:term]
          @countries = @countries.where('lower(name) LIKE ?', params[:q][:term].downcase + '%')
        end
        render :json => @countries.all.map { |item| {:id => item.id, :name => item.name} }
      end
    end
  end

end
