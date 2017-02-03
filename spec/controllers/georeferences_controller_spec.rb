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

describe GeoreferencesController, :type => :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Georeference. As you add validations to Georeference be sure to
  # adjust the attributes here as well.
  let(:collecting_event) { CollectingEvent.create(verbatim_label: "Canada, somewhere cold.") }
  let(:valid_attributes) {
    strip_housekeeping_attributes( FactoryGirl.build(:valid_georeference).attributes )
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GeoreferencesController. Be sure to keep this updated too.
  let(:valid_session) {  }

  describe "GET index" do

    it "assigns projects's recent georeferences as @recent_objects" do
      georeference = Georeference.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to eq([georeference])
    end
  end

  describe "GET show" do
    it "assigns the requested georeference as @georeference" do
      georeference = Georeference.create! valid_attributes

      get :show, params: {:id => georeference.id.to_s}, session: valid_session
      expect(assigns(:georeference)).to eq(georeference)
    end
  end

  # describe "GET new" do
  #   it "assigns a new georeference as @georeference" do
  #     get :new, {}, valid_session
  #     expect(response).to redirect_to(new_geo_locate_path) # 'CollectingEvent.find(valid_attributes['collecting_event_id']))
  #     # expect(assigns(:georeference)).to be_a_new(Georeference)
  #   end
  # end

 describe "GET edit" do
   it "assigns the requested georeference as @georeference" do
     georeference = Georeference.create! valid_attributes
     get :edit, params: {:id => georeference.id.to_s}, session: valid_session
     expect(assigns(:georeference)).to eq(georeference)
   end
 end

  # Move to individual specs
  #describe "POST create" do
  #  describe "with valid params" do
  #    it "creates a new Georeference" do
  #      expect {
  #        post :create, {:georeference => valid_attributes}, valid_session
  #      }.to change(Georeference, :count).by(1)
  #    end

  #    it "assigns a newly created georeference as @georeference" do
  #      post :create, {:georeference => valid_attributes}, valid_session
  #      expect(assigns(:georeference)).to be_a(Georeference)
  #      expect(assigns(:georeference)).to be_persisted
  #    end

  #    it "redirects to the referenced collecting event" do
  #      post :create, {:georeference => valid_attributes}, valid_session
  #      expect(response).to redirect_to(CollectingEvent.find(valid_attributes['collecting_event_id']))
  #    end


  #  end

  #  describe "with invalid params" do
  #    it "assigns a newly created but unsaved georeference as @georeference" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #      post :create, {:georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #      expect(assigns(:georeference)).to be_a_new(Georeference)
  #    end

  #    it "re-renders the 'new' template" do
  #      # Trigger the behavior that occurs when invalid params are submitted
  #      allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #      post :create, {:georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #      expect(response).to render_template("new")
  #    end
  #  end
  #end

  # !! You can't edit georeferences yet

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested georeference" do
  #       georeference = Georeference.create! valid_attributes
  #       # Assuming there are no other georeferences in the database, this
  #       # specifies that the Georeference created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       expect_any_instance_of(Georeference).to receive(:update).with({ "geographic_item_id" => "1" })
  #       put :update, {:id => georeference.id.to_s, :georeference => { "geographic_item_id" => "1" }}, valid_session
  #     end
  #
  #     it "assigns the requested georeference as @georeference" do
  #       georeference = Georeference.create! valid_attributes
  #       put :update, {:id => georeference.id.to_s, :georeference => valid_attributes}, valid_session
  #       expect(assigns(:georeference)).to eq(georeference)
  #     end
  #
  #     it "redirects to the georeference" do
  #       georeference = Georeference.create! valid_attributes
  #       put :update, {:id => georeference.id.to_s, :georeference => valid_attributes}, valid_session
  #       expect(response).to redirect_to(georeference.becomes(Georeference))
  #     end
  #   end
  #
  #   describe "with invalid params" do
  #
  #     it "assigns the georeference as @georeference" do
  #       georeference = Georeference.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #       put :update, {:id => georeference.id.to_s, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #       expect(assigns(:georeference)).to eq(georeference)
  #     end
  #
  #     describe "for a verbatim georeference" do
  #       describe "without a collecting event" do
  #         it "re-renders the 'edit' template" do
  #           georeference = Georeference.new valid_attributes.merge(collecting_event: nil)
  #           # Trigger the behavior that occurs when invalid params are submitted
  #           allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #           put :update, {:id => georeference.id.to_s, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #           expect(response).to render_template("/georeferences/verbatim_data/edit")
  #         end
  #       end
  #
  #       describe "with a collecting event" do
  #         it "re-renders the 'edit' template" do
  #           georeference = Georeference.create! valid_attributes.merge(collecting_event: collecting_event)
  #           # Trigger the behavior that occurs when invalid params are submitted
  #           allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #           put :update, {:id => georeference.id.to_s, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #           expect(response).to render_template("edit")
  #         end
  #       end
  #     end
  #
  #     describe "for a google maps georeference" do
  #       it "re-renders the 'edit' template" do
  #         georeference = Georeference.create! valid_attributes
  #         # Trigger the behavior that occurs when invalid params are submitted
  #         allow_any_instance_of(Georeference).to receive(:save).and_return(false)
  #         put :update, {:id => georeference.id.to_s, :georeference => { "geographic_item_id" => "invalid value" }}, valid_session
  #         expect(response).to render_template("edit")
  #       end
  #     end
  #   end
  # end

  describe "DELETE destroy" do
    it "destroys the requested georeference" do
      georeference = Georeference.create! valid_attributes
      expect {
        delete :destroy, params: {:id => georeference.id.to_s}, session: valid_session
      }.to change(Georeference, :count).by(-1)
    end

    it "redirects to the georeferences list" do
      georeference = Georeference.create! valid_attributes
      delete :destroy, params: {:id => georeference.id.to_s}, session: valid_session
      expect(response).to redirect_to(georeferences_url)
    end
  end

end
