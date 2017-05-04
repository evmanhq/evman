class FormsController < ApplicationController

  before_action :require_modal, only: [:show, :new, :edit]

  def index
    @forms = Form.all.order(:name)
    @form_submission_counts = FormSubmission.group(:form_id).count

    respond_to :html
  end

  def submissions
    @form = current_team.forms.find(params[:id])
    @form_submissions = @form.submissions.order('created_at DESC')

    respond_to :html
  end

  def show
    @form = current_team.forms.find(params[:id])
    @form_submission = @form.submissions.build
    @form_submission_form = FormServices::FormSubmissionForm.new(@form_submission)

    respond_to :html
  end

  def new
    @form = Form.new(team: current_team)

    respond_to :html
  end

  def edit
    @form = current_team.forms.find(params[:id])

    respond_to :html
  end

  def create
    @form = Form.new(form_params)
    @form.team = current_team

    if @form.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def update
    @form = current_team.forms.find(params[:id])

    if @form.update_attributes(form_params)
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private
  def form_params
    params.require(:form).permit(:name, :description, data: {
        fields: [
            :id,
            :label,
            :type,
            :required,
            choices: []
        ]
    })
  end


end
