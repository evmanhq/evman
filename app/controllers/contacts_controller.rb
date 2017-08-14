class ContactsController < ApplicationController
  before_action :require_modal, only: [:new, :edit]
  before_action :find_event, onlu: [:destroy]

  def index
    @contacts = current_team.contacts.order(name: :asc)

    respond_to :html
  end

  def suggest
    @event = Event.find(params[:event_id])
    name, email = params.values_at(:name, :email)

    if name.present?
      @contacts = current_team.contacts
      name = name.split(' ').map { |item| item  + ':*' }.join('&') if name.present?
      @contacts = @contacts.where('to_tsvector(\'english\', f_unaccent(name)) @@ to_tsquery(unaccent(?))', name)
    end

    if email.present? and email.length > 4
      @contacts ||= current_team.contacts
      @contacts = @contacts.where('email ILIKE ?', "#{email}%");
    end

    @contacts ||= Contact.none

    render layout: 'empty'
  end

  def show
    @contact = current_team.contacts.find(params[:id])

    respond_to :html
  end

  def new
    @contact = current_team.contacts.build
    @contact_form = ContactServices::ContactForm.new(@contact, event_id: params[:event_id])

    respond_to :html
  end

  def edit
    @contact = current_team.contacts.find(params[:id])
    @contact_form = ContactServices::ContactForm.new(@contact, event_id: params[:event_id])

    respond_to :html
  end

  def create
    @contact = current_team.contacts.build
    @contact_form = ContactServices::ContactForm.new(@contact, contact_params)

    if @contact_form.submit
      redirect_to @contact_form.redirect_model
    else
      render action: :new
    end
  end

  def update
    @contact = current_team.contacts.find(params[:id])
    @contact_form = ContactServices::ContactForm.new(@contact, contact_params)

    if @contact_form.submit
      redirect_to @contact_form.redirect_model
    else
      render action: :edit
    end
  end

  def destroy
    @contact = current_team.contacts.find(params[:id])
    @contact.destroy

    redirect_to @event || contacts_path
  end

  private
  def contact_params
    params.require(:contact).permit(:name, :job_title, :email, :phone_office, :phone_cell, :team_id, :event_id)
  end

  def find_event
    @event = Event.where(id: params[:event_id]).first
  end
end