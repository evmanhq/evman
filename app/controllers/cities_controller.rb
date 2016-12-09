class CitiesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        @cities = City
        if params[:q] && params[:q][:term]
          q = params[:q][:term].split(' ').map { |item| item  + ':*' }.join('&')
          @cities = @cities.where('to_tsvector(\'english\', f_unaccent(display)) @@ to_tsquery(unaccent(?))', q)
        end
        render :json => @cities.all.map { |item| {:id => item.id, :name => item.display} }
      end
    end
  end

end
