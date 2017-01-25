class PinboardItemsController < ApplicationController
  before_action :require_sign_in
  before_action :set_pinboard_item, only: [:destroy]

  # POST /pinboard_items
  # POST /pinboard_items.json
  def create
    @pinboard_item = PinboardItem.new(pinboard_item_params.merge(user_id: sessions_current_user_id))
    respond_to do |format|
      if @pinboard_item.save
        format.html { redirect_back fallback_location: hub_url, notice: 'Pinboard item was successfully created.' }
        format.json { render json: @pinboard_item, status: :created, location: @pinboard_item }
      else
        format.html { redirect_back fallback_location: hub_url, notice: "Couldn't pin this item! Is it already there?" }
        format.json { render json: @pinboard_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # Stub a "reorder" method
  def update_position
    PinboardItem.reorder(params.require(:order))
    render nothing: true
  end

  # DELETE /pinboard_items/1
  # DELETE /pinboard_items/1.json
  def destroy
    @pinboard_item.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: hub_url, notice: 'Pinboard item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_pinboard_item
    @pinboard_item = PinboardItem.with_project_id($project_id).find(params[:id])
  end

  def pinboard_item_params
    params.require(:pinboard_item).permit(:pinned_object_id, :pinned_object_type, :user_id, :is_inserted, :is_cross_project, :inserted_count)
  end
end
