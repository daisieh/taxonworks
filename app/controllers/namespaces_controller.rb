class NamespacesController < ApplicationController

def batch_load
end

def preview_simple_batch_load
  if params[:file]
    @result = BatchLoad::Import::Namespaces::SimpleInterpreter.new(batch_params)
    digest_cookie(params[:file].tempfile, :Simple_namespaces_md5)
    render 'namespaces/batch_load/simple/preview'
  else
    flash[:notice] = "No file provided!"
    redirect_to action: :batch_load
  end
end

def create_simple_batch_load
  if params[:file] && digested_cookie_exists?(params[:file].tempfile, :Simple_namespaces_md5)
    @result = BatchLoad::Import::Namespaces::SimpleInterpreter.new(batch_params)
    if @result.create
      flash[:notice] = "Successfully proccessed file, #{@result.total_records_created} namespaces were created."
      render 'namespaces/batch_load/simple/create' and return
    else
      flash[:alert] = 'Batch import failed.'
    end
  else
    flash[:alert] = 'File to batch upload must be supplied.'
  end
  render :batch_load
end
  include DataControllerConfiguration::SharedDataControllerConfiguration
  before_action :set_namespace, only: [:show, :edit, :update, :destroy]

  # GET /namespaces
  # GET /namespaces.json
  def index
    @recent_objects = Namespace.order(updated_at: :desc).limit(10)
    render '/shared/data/all/index'
  end

  # GET /namespaces/1
  # GET /namespaces/1.json
  def show
  end

  # GET /namespaces/new
  def new
    @namespace = Namespace.new
  end

  # GET /namespaces/1/edit
  def edit
  end

  # POST /namespaces
  # POST /namespaces.json
  def create
    @namespace = Namespace.new(namespace_params)

    respond_to do |format|
      if @namespace.save
        format.html { redirect_to @namespace, notice: "Namespace '#{@namespace.name}' was successfully created." }
        format.json { render action: 'show', status: :created, location: @namespace }
      else
        format.html { render action: 'new' }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /namespaces/1
  # PATCH/PUT /namespaces/1.json
  def update
    respond_to do |format|
      if @namespace.update(namespace_params)
        format.html { redirect_to @namespace, notice: 'Namespace was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /namespaces/1
  # DELETE /namespaces/1.json
  def destroy
    @namespace.destroy
    respond_to do |format|
      format.html { redirect_to namespaces_url }
      format.json { head :no_content }
    end
  end

  def list
    @namespaces = Namespace.order(:id).page(params[:page]) #.per(10) #.per(3)
  end

  def search
    if params[:id].blank?
      redirect_to namespace_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    else
      redirect_to namespace_path(params[:id])
    end
  end

  def autocomplete
    @namespaces = Namespace.find_for_autocomplete(params)

    data = @namespaces.collect do |t|
      {id: t.id,
       label: ApplicationController.helpers.namespace_tag(t),
       response_values: {
           params[:method] => t.id
       },
       label_html: ApplicationController.helpers.namespace_tag(t)
      }
    end

    render :json => data
  end

  # GET /namespaces/download
  def download
    send_data Namespace.generate_download(Namespace.all), type: 'text', filename: "namespaces_#{DateTime.now.to_s}.csv"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_namespace
    @namespace = Namespace.find(params[:id])
    @recent_object = @namespace
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def namespace_params
    params.require(:namespace).permit(:institution, :name, :short_name, :verbatim_short_name)
  end

  def batch_params
    params.permit(:file, :import_level).merge(user_id:    sessions_current_user_id,
                                              project_id: $project_id).to_h.symbolize_keys
  end
end
