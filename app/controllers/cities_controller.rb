class CitiesController < ApplicationController

  def index
    respond_to do |format|
      format.json do
        q = params[:q][:term].split(' ').map { |item| item  + ':*' }.join('&')
        render :json => City.where('to_tsvector(\'english\', f_unaccent(display)) @@ to_tsquery(unaccent(?))', q).all.map { |item| {:id => item.id, :name => item.display} }
      end
    end
  end

end
