class ConfidencesController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_confidence, only: [:edit, :update, :destroy]

  # GET /confidences
  # GET /confidences.json
  def index
    @recent_objects = Confidence.recent_from_project_id(sessions_current_project_id).order(updated_at: :desc).limit(10)
    render '/shared/data/all/index'
  end

  # GET /confidences/new
  def new
    @confidence_object = confidence_object
  end

  # GET /confidences/1/edit
  def edit
  end

  def list
    @confidences = Confidence.with_project_id(sessions_current_project_id).page(params[:page])
  end

  # POST /confidences
  # POST /confidences.json
  def create
    @confidence = Confidence.new(confidence_params)
    respond_to do |format|
      if @confidence.save
        format.html { redirect_to @confidence.confidence_object.metamorphosize, notice: 'Confidence was successfully created.' }
        format.json { render :show, status: :created, location: @confidence }
      else
        format.html {
          redirect_back fallback_location: hub_url, notice: 'Confidence was NOT successfully created.'
        }
        format.json { render json: @confidence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /confidences/1
  # PATCH/PUT /confidences/1.json
  def update
    respond_to do |format|
      if @confidence.update(confidence_params)
        format.html { redirect_to @confidence, notice: 'Confidence was successfully updated.' }
        format.json { render :show, status: :ok, location: @confidence }
      else
        format.html { render :edit }
        format.json { render json: @confidence.errors, status: :unprocessable_entity }
      end
    end
  end

  def confidence_object_update 
    @confidence_object = confidence_object
    if @confidence_object.update(confidences_params)
      flash[:notice] = 'Successfully updated record.'
    else
      flash[:error] = "Error updating record: #{@confidence_object.errors.full_messages.join('; ')}."
    end
    redirect_to new_confidence_path(confidence_object_type: @confidence_object.class.name, confidence_object_id: @confidence_object.id.to_s)
  end

  # DELETE /confidences/1
  # DELETE /confidences/1.json
  def destroy
    @confidence.destroy
    respond_to do |format|
      format.html { redirect_to confidences_url, notice: 'Confidence was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    if params[:id].blank?
      redirect_to confidences_path, notice: 'You must select an item from the list with a click or tab press before clicking show'
    else
      redirect_to confidence_path(params[:id])
    end
  end

  # GET /confidences/download
  def download
    send_data Download.generate_csv(Confidence.where(project_id: sessions_current_project_id)), type: 'text', filename: "confidences_#{DateTime.now.to_s}.csv"
  end

  private
  
  def set_confidence
    @confidence = Confidence.find(params[:id])
  end

  def confidence_params
    params.require(:confidence).permit(:confidence_level_id, :confidence_object_id, :confidence_object_type)
  end

  def confidence_object
    params.require(:confidence_object_type).constantize.find(params.require(:confidence_object_id))
  end

  def confidences_params
    params.require(:confidence_object).permit(
      confidences_attributes: [:_destroy, :id, :confidence_level_id]
    )
  end

end
