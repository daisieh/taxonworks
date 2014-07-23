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

describe NamespacesController, :type => :controller do
  before(:each) {
    sign_in_administrator
  }

  # This should return the minimal set of attributes required to create a valid
  # Georeference. As you add validations to Georeference be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { 
    strip_housekeeping_attributes( FactoryGirl.build(:valid_namespace).attributes )
  } 

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # NamespacesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all namespaces as @namespaces" do
      namespace = Namespace.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:namespaces)).to eq([namespace])
    end
  end

  describe "GET show" do
    it "assigns the requested namespace as @namespace" do
      namespace = Namespace.create! valid_attributes
      get :show, {:id => namespace.to_param}, valid_session
      expect(assigns(:namespace)).to eq(namespace)
    end
  end

  describe "GET new" do
    it "assigns a new namespace as @namespace" do
      get :new, {}, valid_session
      expect(assigns(:namespace)).to be_a_new(Namespace)
    end
  end

  describe "GET edit" do
    it "assigns the requested namespace as @namespace" do
      namespace = Namespace.create! valid_attributes
      get :edit, {:id => namespace.to_param}, valid_session
      expect(assigns(:namespace)).to eq(namespace)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Namespace" do
        expect {
          post :create, {:namespace => valid_attributes}, valid_session
        }.to change(Namespace, :count).by(1)
      end

      it "assigns a newly created namespace as @namespace" do
        post :create, {:namespace => valid_attributes}, valid_session
        expect(assigns(:namespace)).to be_a(Namespace)
        expect(assigns(:namespace)).to be_persisted
      end

      it "redirects to the created namespace" do
        post :create, {:namespace => valid_attributes}, valid_session
        expect(response).to redirect_to(Namespace.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved namespace as @namespace" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Namespace).to receive(:save).and_return(false)
        post :create, {:namespace => { "institution" => "invalid value" }}, valid_session
        expect(assigns(:namespace)).to be_a_new(Namespace)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Namespace).to receive(:save).and_return(false)
        post :create, {:namespace => { "institution" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested namespace" do
        namespace = Namespace.create! valid_attributes
        # Assuming there are no other namespaces in the database, this
        # specifies that the Namespace created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Namespace).to receive(:update).with({ "institution" => "MyString" })
        put :update, {:id => namespace.to_param, :namespace => { "institution" => "MyString" }}, valid_session
      end

      it "assigns the requested namespace as @namespace" do
        namespace = Namespace.create! valid_attributes
        put :update, {:id => namespace.to_param, :namespace => valid_attributes}, valid_session
        expect(assigns(:namespace)).to eq(namespace)
      end

      it "redirects to the namespace" do
        namespace = Namespace.create! valid_attributes
        put :update, {:id => namespace.to_param, :namespace => valid_attributes}, valid_session
        expect(response).to redirect_to(namespace)
      end
    end

    describe "with invalid params" do
      it "assigns the namespace as @namespace" do
        namespace = Namespace.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Namespace).to receive(:save).and_return(false)
        put :update, {:id => namespace.to_param, :namespace => { "institution" => "invalid value" }}, valid_session
        expect(assigns(:namespace)).to eq(namespace)
      end

      it "re-renders the 'edit' template" do
        namespace = Namespace.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Namespace).to receive(:save).and_return(false)
        put :update, {:id => namespace.to_param, :namespace => { "institution" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested namespace" do
      namespace = Namespace.create! valid_attributes
      expect {
        delete :destroy, {:id => namespace.to_param}, valid_session
      }.to change(Namespace, :count).by(-1)
    end

    it "redirects to the namespaces list" do
      namespace = Namespace.create! valid_attributes
      delete :destroy, {:id => namespace.to_param}, valid_session
      expect(response).to redirect_to(namespaces_url)
    end
  end

end
