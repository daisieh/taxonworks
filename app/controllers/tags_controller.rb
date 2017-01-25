class TagsController < ApplicationController
  include DataControllerConfiguration::ProjectDataControllerConfiguration

  before_action :set_tag, only: [:update, :destroy]

  def new
    if !Keyword.for_tags.with_project_id(sessions_current_project_id).any? # if there are none
      @return_path = "/tags/new?tag[tag_object_attribute]=&tag[tag_object_id]=#{params[:tag][:tag_object_id]}&tag[tag_object_type]=#{params[:tag][:tag_object_type]}"
      redirect_to new_controlled_vocabulary_term_path(return_path: @return_path), notice: 'Create a keyword or two first!' and return
    end
    @tag = Tag.new(tag_params)
  end

  # GET /tags
  # GET /tags.json
  def index
    @recent_objects = Tag.recent_from_project_id(sessions_current_project_id).order(updated_at: :desc).limit(10)
    render '/shared/data/all/index'
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)
    # redirect_url = (request.env['HTTP_REFERER'].include?(new_tag_path) ? @tag : :back)
    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag.tag_object.metamorphosize, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html {
          # if redirect_url == :back
          redirect_back fallback_location: hub_url, notice: 'Tag was NOT successfully created.'
          # else
          #   render :new
          # end
        }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1
  # PATCH/PUT /tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag.tag_object.metamorphosize, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { redirect_back fallback_location: hub_url, notice: 'Tag was NOT successfully updated.' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    # redirect_url = (request.env['HTTP_REFERER'].include?("tags/#{@tag.id}") ? tags_url : :back)
    @tag.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: hub_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def list
    @tags = Tag.where(project_id: sessions_current_project_id).order(:tag_object_type).page(params[:page])
  end

  # GET /tags/search
  def search
    if params[:id].blank?
      redirect_to tags_path, notice: 'You must select an item from the list with a click or tab press before clicking show.'
    else
      redirect_to tag_path(params[:id])
    end
  end

  def autocomplete
    @tags = Tag.find_for_autocomplete(params)

    data = @tags.collect do |t|
      {id: t.id,
       label: ApplicationController.helpers.tag_tag(t),
       response_values: {
           params[:method] => t.id
       },
       label_html: ApplicationController.helpers.tag_tag(t)
      }
    end

    render :json => data
  end

  # GET /tags/download
  def download
    send_data Tag.generate_download(Tag.where(project_id: $project_id)), type: 'text', filename: "tags_#{DateTime.now.to_s}.csv"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.with_project_id($project_id).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tag_params
    params.require(:tag).permit(:keyword_id, :tag_object_id, :tag_object_type, :tag_object_attribute)
  end
end
