class AttachmentsController < ApplicationController

  def edit

  end

  def create
    @attachment = Attachment.create(attachment_params)
    @attachment.user = current_user
    if @attachment.save
      redirect_to(@attachment.redirect_path)
    else
      render action: :edit
    end
  end

  def show
    attachment = Attachment.find(params[:id])
    authorize! attachment.parent, :read
    if Rails.env.development?
      data = File.read(attachment.file.path)
      send_data data, disposition: :inline, type: attachment.file.content_type
    else
      nginx_download(attachment.file.expiring_url(10))
    end
  end

  def destroy
    attachment = Attachment.find(params[:id])
    authorize! attachment.parent, :update
    attachment.destroy

    redirect_to attachment.redirect_path
  end

  private
  def attachment_params
    params.require(:attachment).permit(:file, :name, :parent_id, :parent_type)
  end
end
