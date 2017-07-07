class Api::TokensController < ApplicationController

  skip_before_action :authenticate!, :require_team!
  protect_from_forgery except: :validation

  def validation
    data = MultiJson.load(request.body.read)
    token = ApiToken.where(token: data['token']).first

    return render status: 403, json: {} unless token

    if token.team
      render json: { team: token.team.id }
    elsif token.user
      render json: { user: token.user.id }
    else
      render status: 5000, json: {}
    end
  end

end
