require 'spec_helper'

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

describe BiocurationClassificationsController do

  # This should return the minimal set of attributes required to create a valid
  # BiocurationClassification. As you add validations to BiocurationClassification, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "biocuration_class_id" => "1" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BiocurationClassificationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all biocuration_classifications as @biocuration_classifications" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      get :index, {}, valid_session
      assigns(:biocuration_classifications).should eq([biocuration_classification])
    end
  end

  describe "GET show" do
    it "assigns the requested biocuration_classification as @biocuration_classification" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      get :show, {:id => biocuration_classification.to_param}, valid_session
      assigns(:biocuration_classification).should eq(biocuration_classification)
    end
  end

  describe "GET new" do
    it "assigns a new biocuration_classification as @biocuration_classification" do
      get :new, {}, valid_session
      assigns(:biocuration_classification).should be_a_new(BiocurationClassification)
    end
  end

  describe "GET edit" do
    it "assigns the requested biocuration_classification as @biocuration_classification" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      get :edit, {:id => biocuration_classification.to_param}, valid_session
      assigns(:biocuration_classification).should eq(biocuration_classification)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BiocurationClassification" do
        expect {
          post :create, {:biocuration_classification => valid_attributes}, valid_session
        }.to change(BiocurationClassification, :count).by(1)
      end

      it "assigns a newly created biocuration_classification as @biocuration_classification" do
        post :create, {:biocuration_classification => valid_attributes}, valid_session
        assigns(:biocuration_classification).should be_a(BiocurationClassification)
        assigns(:biocuration_classification).should be_persisted
      end

      it "redirects to the created biocuration_classification" do
        post :create, {:biocuration_classification => valid_attributes}, valid_session
        response.should redirect_to(BiocurationClassification.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved biocuration_classification as @biocuration_classification" do
        # Trigger the behavior that occurs when invalid params are submitted
        BiocurationClassification.any_instance.stub(:save).and_return(false)
        post :create, {:biocuration_classification => { "biocuration_class_id" => "invalid value" }}, valid_session
        assigns(:biocuration_classification).should be_a_new(BiocurationClassification)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        BiocurationClassification.any_instance.stub(:save).and_return(false)
        post :create, {:biocuration_classification => { "biocuration_class_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested biocuration_classification" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Assuming there are no other biocuration_classifications in the database, this
        # specifies that the BiocurationClassification created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        BiocurationClassification.any_instance.should_receive(:update).with({ "biocuration_class_id" => "1" })
        put :update, {:id => biocuration_classification.to_param, :biocuration_classification => { "biocuration_class_id" => "1" }}, valid_session
      end

      it "assigns the requested biocuration_classification as @biocuration_classification" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        put :update, {:id => biocuration_classification.to_param, :biocuration_classification => valid_attributes}, valid_session
        assigns(:biocuration_classification).should eq(biocuration_classification)
      end

      it "redirects to the biocuration_classification" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        put :update, {:id => biocuration_classification.to_param, :biocuration_classification => valid_attributes}, valid_session
        response.should redirect_to(biocuration_classification)
      end
    end

    describe "with invalid params" do
      it "assigns the biocuration_classification as @biocuration_classification" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BiocurationClassification.any_instance.stub(:save).and_return(false)
        put :update, {:id => biocuration_classification.to_param, :biocuration_classification => { "biocuration_class_id" => "invalid value" }}, valid_session
        assigns(:biocuration_classification).should eq(biocuration_classification)
      end

      it "re-renders the 'edit' template" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        BiocurationClassification.any_instance.stub(:save).and_return(false)
        put :update, {:id => biocuration_classification.to_param, :biocuration_classification => { "biocuration_class_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested biocuration_classification" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      expect {
        delete :destroy, {:id => biocuration_classification.to_param}, valid_session
      }.to change(BiocurationClassification, :count).by(-1)
    end

    it "redirects to the biocuration_classifications list" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      delete :destroy, {:id => biocuration_classification.to_param}, valid_session
      response.should redirect_to(biocuration_classifications_url)
    end
  end

end
