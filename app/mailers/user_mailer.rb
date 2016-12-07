class UserMailer < ApplicationMailer

  def new_invitation(invitation)
    @invitation = invitation
    @url  = ENV['EVMAN_HOST'] + '/?invitation=' + invitation.code
    mail(to: @invitation.email, subject: 'You have been invited to EvMan.io')
  end

  def email_change_request(request)
    @request = request
    @url  = ENV['EVMAN_HOST'] + "/users/#{request.user.id}/email_confirmation?code=#{request.code}"
    mail(to: @request.email, subject: 'Confirm your new e-mail for EvMan.io')
  end

end
