class AttachmentsController < ApplicationController

  def create
    attachment = Attachment.create(params.require(:attachment).permit(:file, :name, :parent_id, :parent_type))
    attachment.user = current_user
    attachment.save

    redirect_to(url_for(attachment.parent))
  end

  def show
    attachment = Attachment.find(params[:id])
    authorize! attachment.parent, :read
    if Rails.env.development?
      data = File.read(attachment.file.path)
      send_data data, disposition: :inline, type: attachment.file.content_type
    else
      nginx_download(attachment.file.url)
    end
  end
end
