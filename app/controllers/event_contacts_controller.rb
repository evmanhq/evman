class EventContactsController < ApplicationController
  def create
    event = current_team.events.find(params[:id])
    contact = current_team.contacts.find(params[:contact_id])

    assigner = ContactServices::EventAssigner.new(contact: contact, event: event)
    assigner.perform

    redirect_to event
  end

  def destroy
    event = current_team.events.find(params[:id])
    contact = current_team.contacts.find(params[:contact_id])

    revoker = ContactServices::EventRevoker.new(contact: contact, event: event)
    revoker.perform

    redirect_to event
  end
end