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

RSpec.describe CollectionObjectObservationsController, type: :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # CollectionObjectObservation. As you add validations to CollectionObjectObservation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { strip_housekeeping_attributes(FactoryGirl.build(:valid_collection_object_observation).attributes)
  }

  let(:invalid_attributes) {
    {data: nil} 
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CollectionObjectObservationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all collection_object_observations as @recent_objects" do
      collection_object_observation = CollectionObjectObservation.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to eq([collection_object_observation])
    end
  end

  describe "GET #show" do
    it "assigns the requested collection_object_observation as @collection_object_observation" do
      collection_object_observation = CollectionObjectObservation.create! valid_attributes
      get :show, params: {:id => collection_object_observation.to_param}, session: valid_session
      expect(assigns(:collection_object_observation)).to eq(collection_object_observation)
    end
  end

  describe "GET #new" do
    it "assigns a new collection_object_observation as @collection_object_observation" do
      get :new, params: {}, session: valid_session
      expect(assigns(:collection_object_observation)).to be_a_new(CollectionObjectObservation)
    end
  end

  describe "GET #edit" do
    it "assigns the requested collection_object_observation as @collection_object_observation" do
      collection_object_observation = CollectionObjectObservation.create! valid_attributes
      get :edit, params: {:id => collection_object_observation.to_param}, session: valid_session
      expect(assigns(:collection_object_observation)).to eq(collection_object_observation)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CollectionObjectObservation" do
        expect {
          post :create, params: {:collection_object_observation => valid_attributes}, session: valid_session
        }.to change(CollectionObjectObservation, :count).by(1)
      end

      it "assigns a newly created collection_object_observation as @collection_object_observation" do
        post :create, params: {:collection_object_observation => valid_attributes}, session: valid_session
        expect(assigns(:collection_object_observation)).to be_a(CollectionObjectObservation)
        expect(assigns(:collection_object_observation)).to be_persisted
      end

      it "redirects to the created collection_object_observation" do
        post :create, params: {:collection_object_observation => valid_attributes}, session: valid_session
        expect(response).to redirect_to(CollectionObjectObservation.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved collection_object_observation as @collection_object_observation" do
        post :create, params: {:collection_object_observation => invalid_attributes}, session: valid_session
        expect(assigns(:collection_object_observation)).to be_a_new(CollectionObjectObservation)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:collection_object_observation => invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:data) { "some new data\r\n"}
      let(:new_attributes) {
        {data: data}
      }

      it "updates the requested collection_object_observation" do
        collection_object_observation = CollectionObjectObservation.create! valid_attributes
        put :update, params: {:id => collection_object_observation.to_param, :collection_object_observation => new_attributes}, session: valid_session
        collection_object_observation.reload
        expect(collection_object_observation.data).to eq(data)
      end

      it "assigns the requested collection_object_observation as @collection_object_observation" do
        collection_object_observation = CollectionObjectObservation.create! valid_attributes
        put :update, params: {:id => collection_object_observation.to_param, :collection_object_observation => valid_attributes}, session: valid_session
        expect(assigns(:collection_object_observation)).to eq(collection_object_observation)
      end

      it "redirects to the collection_object_observation" do
        collection_object_observation = CollectionObjectObservation.create! valid_attributes
        put :update, params: {:id => collection_object_observation.to_param, :collection_object_observation => valid_attributes}, session: valid_session
        expect(response).to redirect_to(collection_object_observation)
      end
    end

    context "with invalid params" do
      it "assigns the collection_object_observation as @collection_object_observation" do
        collection_object_observation = CollectionObjectObservation.create! valid_attributes
        put :update, params: {:id => collection_object_observation.to_param, :collection_object_observation => invalid_attributes}, session: valid_session
        expect(assigns(:collection_object_observation)).to eq(collection_object_observation)
      end

      it "re-renders the 'edit' template" do
        collection_object_observation = CollectionObjectObservation.create! valid_attributes
        put :update, params: {:id => collection_object_observation.to_param, :collection_object_observation => invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested collection_object_observation" do
      collection_object_observation = CollectionObjectObservation.create! valid_attributes
      expect {
        delete :destroy, params: {:id => collection_object_observation.to_param}, session: valid_session
      }.to change(CollectionObjectObservation, :count).by(-1)
    end

    it "redirects to the collection_object_observations list" do
      collection_object_observation = CollectionObjectObservation.create! valid_attributes
      delete :destroy, params: {:id => collection_object_observation.to_param}, session: valid_session
      expect(response).to redirect_to(collection_object_observations_url)
    end
  end

end
