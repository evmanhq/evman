class LanguagesController < ApplicationController
  def index
    term = "#{params[:q]}%"
    languages = Language.where("name ILIKE ? OR code ILIKE ?", term, term).all.map do |lang|
      { id: lang.id, text: lang.name }
    end

    render json: languages
  end
end
