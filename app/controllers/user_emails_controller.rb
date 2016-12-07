class UserEmailsController < ApplicationController

  def show
    email = UserEmail.find(params[:id])
    return redirect_to(user_path(current_user)) if email.user != current_user
    current_user.email = email.email
    current_user.save
    redirect_to(user_path(current_user))
  end

  def destroy
    email = UserEmail.find(params[:id])
    return redirect_to(user_path(current_user)) if email.user != current_user
    return redirect_to(user_path(current_user)) if email.email == current_user.email
    email.destroy!
    redirect_to(user_path(current_user))
  end

end
