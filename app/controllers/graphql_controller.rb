class GraphqlController < ApplicationController
  skip_before_action :require_team!
  skip_before_action :announcements
  skip_before_action :breadcrumb_nav
  skip_before_action :verify_authenticity_token

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
      current_team: current_team
    }

    result = EvmanSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  # Owerrite before actions from application controller
  def authenticate!
    unless current_user
      head :unauthorized
      return false
    end

    if current_team and !current_user.teams.include?(current_team)
      render inline: "Forbidden to access team #{current_team.name}", status: :forbidden
      return false
    end

    Authorization.activate(current_user, current_team)
  end
end
