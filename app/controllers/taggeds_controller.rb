class TaggedsController < ApplicationController

  def edit
    @item = recognize_item
    @taggeds_form = TaggedServices::Form.new @item

    respond_to :html
  end

  def update
    @item = recognize_item
    @taggeds_form = TaggedServices::Form.new @item, taggeds_form_params
    @taggeds_form.submit

    redirect_to @item
  end

  private
  def taggeds_form_params
    params.require(:taggeds_form).permit(tag_names: [])
  end

  def recognize_item
    raise StandardError, "item not specified" if params[:item].blank?

    item_class_name = params[:item].classify
    item_class = item_class_name.safe_constantize
    raise StandardError, "item class `#{item_class_name}` not found" unless item_class

    item_class.find(params[:id])
  end

end
