class TaxonNameClassificationsController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_taxon_name_classification, only: [:update, :destroy]

  # GET /taxon_name_relationships
  # GET /taxon_name_relationships.json
  def index
    @recent_objects = TaxonNameClassification.recent_from_project_id(sessions_current_project_id).order(updated_at: :desc).limit(10)
    render '/shared/data/all/index'
  end

  # POST /taxon_name_classifications
  # POST /taxon_name_classifications.json
  def create
    @taxon_name_classification = TaxonNameClassification.new(taxon_name_classification_params)

    respond_to do |format|
      if @taxon_name_classification.save
        format.html { redirect_to @taxon_name_classification.taxon_name.metamorphosize, notice: 'Taxon name classification was successfully created.' }
        format.json { render json: @taxon_name_classification, status: :created, location: @taxon_name_classification.metamorphosize }
      else
        format.html { redirect_back fallback_location: hub_url, notice: 'Taxon name classification was NOT successfully created.' }
        format.json { render json: @taxon_name_classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taxon_name_classifications/1
  # PATCH/PUT /taxon_name_classifications/1.json
  def update
    respond_to do |format|
      if @taxon_name_classification.update(taxon_name_classification_params)
        format.html { redirect_back fallback_location: hub_url, notice: 'Taxon name classification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_back fallback_location: hub_url, notice: 'Taxon name classification was NOT successfully updated.' }
        format.json { render json: @taxon_name_classification.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    taxon_name_id = params[:taxon_name_classification].try(:[], :taxon_name_id)

    taxon_name = TaxonName.where(
      id:         taxon_name_id,
      project_id: $project_id
    ).first

    @taxon_name_classification = TaxonNameClassification.new(
      taxon_name: taxon_name ? taxon_name : TaxonName.new()
    )
  end

  # DELETE /taxon_name_classifications/1
  # DELETE /taxon_name_classifications/1.json
  def destroy
    @taxon_name_classification.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: hub_url, notice: 'Taxon name classification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list
    @taxon_name_classifications = TaxonNameClassification.with_project_id(sessions_current_project_id).order(:id).page(params[:page])
  end

  # GET /taxon_name_classifications/search
  def search
    if params[:id].blank?
      redirect_to taxon_name_classification_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    else
      redirect_to taxon_name_classification_path(params[:id])
    end
  end

  def autocomplete
    @taxon_name_classifications = taxon_name_classification.find_for_autocomplete(params.merge(project_id: sessions_current_project_id))
    data                        = @taxon_name_classifications.collect do |t|
      {id:              t.id,
       label:           TaxonNameClassificationsHelper.taxon_name_classification_tag(t),
       response_values: {
         params[:method] => t.id
       },
       label_html:      TaxonNameClassificationsHelper.taxon_name_classification_tag(t) #  render_to_string(:partial => 'shared/autocomplete/taxon_name.html', :object => t)
      }
    end

    render :json => data
  end

  # GET /taxon_name_classifications/download
  def download
    send_data TaxonNameClassification.generate_download(TaxonNameClassification.where(project_id: $project_id)), type: 'text', filename: "taxon_name_classifications_#{DateTime.now.to_s}.csv"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_taxon_name_classification
    @taxon_name_classification = TaxonNameClassification.with_project_id($project_id).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def taxon_name_classification_params
    params.require(:taxon_name_classification).permit(:taxon_name_id, :type)
  end
end
