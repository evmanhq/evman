class FormSubmissionsController < ApplicationController

  before_action :require_modal, only: [:show, :new, :edit]

  def index
    @form_submissions = FormSubmission.order('created_at DESC')

    respond_to :html
  end

  def new
    @form = current_team.forms.find(params[:form_id])
    @form_submission = @form.submissions.build(associated_object_type: params[:associated_object_type],
                                               associated_object_id: params[:associated_object_id])
    @form_submission_form = FormServices::FormSubmissionForm.new(@form_submission)

    respond_to :html
  end

  def show
    @form_submission = FormSubmission.find(params[:id])
    @form_submission_decorator = FormServices::FormSubmissionDecorator.new(@form_submission)

    respond_to :html
  end


  def edit
    @form_submission = FormSubmission.find(params[:id])
    @form_submission_form = FormServices::FormSubmissionForm.new(@form_submission)

    respond_to :html
  end

  def create
    @form = current_team.forms.find(form_submission_params[:form_id])
    @form_submission = @form.submissions.build(associated_object_type: form_submission_params[:associated_object_type],
                                               associated_object_id: form_submission_params[:associated_object_id])
    @form_submission_form = FormServices::FormSubmissionForm.new(@form_submission, current_user, form_submission_params)

    if @form_submission_form.submit
      redirect_to @form_submission
    else
      render action: :new
    end
  end

  def update
    @form_submission = FormSubmission.find(params[:id])
    @form_submission_form = FormServices::FormSubmissionForm.new(@form_submission, current_user, form_submission_params)
    
    if @form_submission_form.submit
      redirect_to @form_submission
    else
      render action: :edit
    end
  end

  def form_submission_params
    params['form_submission']
  end
end
