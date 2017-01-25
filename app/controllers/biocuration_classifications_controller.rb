class BiocurationClassificationsController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_biocuration_classification, only: [:update, :destroy]

  # POST /biocuration_classifications
  # POST /biocuration_classifications.json
  def create
    @biocuration_classification = BiocurationClassification.new(biocuration_classification_params)

    respond_to do |format|
      if @biocuration_classification.save
        format.html { redirect_back fallback_location: hub_url, notice: 'Biocuration classification was successfully created.' }
        format.json { render json: @biocuration_classification, status: :created, location: @biocuration_classification }
      else
        format.html { redirect_back fallback_location: hub_url, notice: 'Biocuration classification was NOT successfully created.' }
        format.json { render json: @biocuration_classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /biocuration_classifications/1
  # PATCH/PUT /biocuration_classifications/1.json
  def update
    respond_to do |format|
      if @biocuration_classification.update(biocuration_classification_params)
        format.html { redirect_back fallback_location: hub_url, notice: 'Biocuration classification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_back fallback_location: hub_url, notice: 'Biocuration classification was NOT successfully updated.' }
        format.json { render json: @biocuration_classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /biocuration_classifications/1
  # DELETE /biocuration_classifications/1.json
  def destroy
    @biocuration_classification.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: hub_url, notice: 'Biocuration classification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_biocuration_classification
      @biocuration_classification = BiocurationClassification.with_project_id($project_id).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def biocuration_classification_params
      params.require(:biocuration_classification).permit(:biocuration_class_id, :biological_collection_object_id)
    end
end
