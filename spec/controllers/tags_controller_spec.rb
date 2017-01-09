require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe TagsController, :type => :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Tag. As you add validations to Tag, be sure to
  # adjust the attributes here as well.
  let(:o) { FactoryGirl.create(:valid_otu) }
  let(:k) { FactoryGirl.create(:valid_keyword) }
  let(:valid_attributes) {
    {tag_object_id: o.id, tag_object_type: o.class.to_s, keyword_id: k.to_param} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TagsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns recent tags as @recent_objects" do
      tag = Tag.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to include(tag)
    end
  end

  # describe "GET show" do
  #   it "assigns the requested tag as @tag" do
  #     tag = Tag.create! valid_attributes
  #     get :show, {:id => tag.to_param}, valid_session
  #     expect(assigns(:tag)).to eq(tag)
  #   end
  # end
  #
  # describe "GET new" do
  #   it "assigns a new tag as @tag" do
  #     get :new, {}, valid_session
  #     expect(assigns(:tag)).to be_a_new(Tag)
  #   end
  # end
  #
  # describe "GET edit" do
  #   it "assigns the requested tag as @tag" do
  #     tag = Tag.create! valid_attributes
  #     get :edit, {:id => tag.to_param}, valid_session
  #     expect(assigns(:tag)).to eq(tag)
  #   end
  # end

  before {
    request.env['HTTP_REFERER'] = list_otus_path # logical example
  }

  describe "POST create" do # todo @mjy since there is no new_tag_path anymore, can this structure be simplified? Not really different from some of the other ones.
    # context 'originating from new_tag_path()' do
    #   before {
    #     request.env["HTTP_REFERER"] = new_tag_path
    #   }

    describe "with valid params" do
      it "creates a new Tag" do
        expect {
          post :create, params: {:tag => valid_attributes}, session: valid_session
        }.to change(Tag, :count).by(1)
      end

      it "assigns a newly created tag as @tag" do
        post :create, params: {:tag => valid_attributes}, session: valid_session
        expect(assigns(:tag)).to be_a(Tag)
        expect(assigns(:tag)).to be_persisted
      end

      it "redirects to :back" do
        post :create, params: {:tag => valid_attributes}, session: valid_session
        expect(response).to redirect_to(otu_path(o))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved tag as @tag" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Tag).to receive(:save).and_return(false)
        post :create, params: {:tag => {"keyword_id" => "invalid value"}}, session: valid_session
        expect(assigns(:tag)).to be_a_new(Tag)
      end

      it "re-renders the :back template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Tag).to receive(:save).and_return(false)
        post :create, params: {:tag => {"keyword_id" => "invalid value"}}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end
    # end

    # context 'NOT originating from new_tag_path()' do
    #   before {
    #     @referer = hub_path
    #     request.env["HTTP_REFERER"] = @referer # just picking a non-new path
    #   }
    #
    #   it 'redirects to :back on successful create' do
    #     post :create, {:tag => valid_attributes}, valid_session
    #     expect(response).to redirect_to(@referer)
    #   end
    #
    #   it 'redirects to :back on unsuccessful create' do
    #     post :create, {:tag => { "keyword_id" => "invalid value" } }, valid_session
    #     expect(response).to redirect_to(@referer)
    #   end
    # end

  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested tag" do
        tag = Tag.create! valid_attributes
        # Assuming there are no other tags in the database, this
        # specifies that the Tag created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Tag).to receive(:update).with({"keyword_id" => "1"})
        put :update, params: {:id => tag.to_param, :tag => {"keyword_id" => "1"}}, session: valid_session
      end

      it "assigns the requested tag as @tag" do
        tag = Tag.create! valid_attributes
        put :update, params: {:id => tag.to_param, :tag => valid_attributes}, session: valid_session
        expect(assigns(:tag)).to eq(tag)
      end

      it "redirects to :back" do
        tag = Tag.create! valid_attributes
        put :update, params: {:id => tag.to_param, :tag => valid_attributes}, session: valid_session
        expect(response).to redirect_to(otu_path(o))
      end
    end

    describe "with invalid params" do
      it "assigns the tag as @tag" do
        tag = Tag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Tag).to receive(:save).and_return(false)
        put :update, params: {:id => tag.to_param, :tag => {"keyword_id" => "invalid value"}}, session: valid_session
        expect(assigns(:tag)).to eq(tag)
      end

      it "re-renders the :back template" do
        tag = Tag.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Tag).to receive(:save).and_return(false)
        put :update, params: {:id => tag.to_param, :tag => {"keyword_id" => "invalid value"}}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end
  end

  describe "DELETE destroy" do
    # context 'originating from tag_path()' do
    before {
      @tag = Tag.create! valid_attributes
      request.env["HTTP_REFERER"] = list_otus_path
    }

    it "destroys the requested tag" do
      expect {
        delete :destroy, params: {:id => @tag.to_param}, session: valid_session
      }.to change(Tag, :count).by(-1)
    end

    it "redirects to :back" do
      #   it "redirects to the tags list if arriving from tag_path" do
      delete :destroy, params: {:id => @tag.to_param}, session: valid_session
      expect(response).to redirect_to(list_otus_path)
      # end
    end

    # context 'originating from somewhere else' do
    #   it "redirects to :back tags list if not arriving from tag_path" do
    #     p = hub_path
    #     request.env["HTTP_REFERER"] = p
    #     tag = Tag.create! valid_attributes
    #     delete :destroy, {:id => tag.to_param}, valid_session
    #     expect(response).to redirect_to(p)
    #   end
    # end


  end

end
