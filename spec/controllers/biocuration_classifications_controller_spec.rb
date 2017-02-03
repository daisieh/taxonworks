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

describe BiocurationClassificationsController, :type => :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # BiocurationClassification. As you add validations to BiocurationClassification, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { strip_housekeeping_attributes( FactoryGirl.build(:valid_biocuration_classification).attributes) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BiocurationClassificationsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before {
    request.env['HTTP_REFERER'] = list_otus_path # logical example
  }

  describe "POST create" do
    describe "with valid params" do
      it "creates a new BiocurationClassification" do
        expect {
          post :create, params: {:biocuration_classification => valid_attributes}, session: valid_session
        }.to change(BiocurationClassification, :count).by(1)
      end

      it "assigns a newly created biocuration_classification as @biocuration_classification" do
        post :create, params: {:biocuration_classification => valid_attributes}, session: valid_session
        expect(assigns(:biocuration_classification)).to be_a(BiocurationClassification)
        expect(assigns(:biocuration_classification)).to be_persisted
      end

      it "redirects to :back" do
        post :create, params: {:biocuration_classification => valid_attributes}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved biocuration_classification as @biocuration_classification" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BiocurationClassification).to receive(:save).and_return(false)
        post :create, params: {:biocuration_classification => { "biocuration_class_id" => "invalid value" }}, session: valid_session
        expect(assigns(:biocuration_classification)).to be_a_new(BiocurationClassification)
      end

      it "re-renders the :back template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BiocurationClassification).to receive(:save).and_return(false)
        post :create, params: {:biocuration_classification => { "biocuration_class_id" => "invalid value" }}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      let(:update_params) { ActionController::Parameters.new({'biocuration_class_id' => 'true'})
                              .permit(:biocuration_class_id) }

      it 'updates the requested biocuration_classification' do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Assuming there are no other biocuration_classifications in the database, this
        # specifies that the BiocurationClassification created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(BiocurationClassification).to receive(:update).with(update_params)
        put :update, params: {:id => biocuration_classification.id.to_s, :biocuration_classification => {'biocuration_class_id' => 'true'}}, session: valid_session
      end

      it 'assigns the requested biocuration_classification as @biocuration_classification' do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        put :update, params: {:id => biocuration_classification.id.to_s, :biocuration_classification => valid_attributes}, session: valid_session
        expect(assigns(:biocuration_classification)).to eq(biocuration_classification)
      end

      it 'redirects to :back' do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        put :update, params: {:id => biocuration_classification.id.to_s, :biocuration_classification => valid_attributes}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end

    describe "with invalid params" do
      it "assigns the biocuration_classification as @biocuration_classification" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BiocurationClassification).to receive(:save).and_return(false)
        put :update, params: {:id => biocuration_classification.id.to_s, :biocuration_classification => {"biocuration_class_id" => "invalid value"}}, session: valid_session
        expect(assigns(:biocuration_classification)).to eq(biocuration_classification)
      end

      it "re-renders the :back template" do
        biocuration_classification = BiocurationClassification.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(BiocurationClassification).to receive(:save).and_return(false)
        put :update, params: {:id => biocuration_classification.id.to_s, :biocuration_classification => {"biocuration_class_id" => "invalid value"}}, session: valid_session
        expect(response).to redirect_to(list_otus_path)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested biocuration_classification" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      expect {
        delete :destroy, params: {:id => biocuration_classification.id.to_s}, session: valid_session
      }.to change(BiocurationClassification, :count).by(-1)
    end

    it "redirects to :back" do
      biocuration_classification = BiocurationClassification.create! valid_attributes
      delete :destroy, params: {:id => biocuration_classification.id.to_s}, session: valid_session
      expect(response).to redirect_to(list_otus_path)
    end
  end

end
