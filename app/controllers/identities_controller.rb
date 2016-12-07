class IdentitiesController < ApplicationController

  def destroy
    identity = Identity.find(params[:id])
    return redirect_to(user_path(current_user)) if identity.user != current_user
    identity.destroy
    redirect_to(user_path(current_user))
  end

end
