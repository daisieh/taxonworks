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

describe CollectingEventsController, :type => :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Georeference. As you add validations to Georeference be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    strip_housekeeping_attributes(FactoryGirl.build(:valid_collecting_event).attributes)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CollectingEventsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET list" do
    it "with no other parameters, assigns 20/page collecting_events as @controlled_vocabulary_terms" do
      collecting_event = CollectingEvent.create! valid_attributes
      get :list, params: {}, session: valid_session
      expect(assigns(:collecting_events)).to include(collecting_event)
    end

    it "renders the list template" do
      get :list, params: {}, session: valid_session
      expect(response).to render_template("list")
    end
  end

  describe "GET index" do
    it "assigns all collecting_events as @collecting_events" do
      collecting_event = CollectingEvent.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to include(collecting_event)
    end
  end

  describe "GET show" do
    it "assigns the requested collecting_event as @collecting_event" do
      collecting_event = CollectingEvent.create! valid_attributes
      get :show, params: {:id => collecting_event.to_param}, session: valid_session
      expect(assigns(:collecting_event)).to eq(collecting_event)
    end
  end

  describe "GET new" do
    it "assigns a new collecting_event as @collecting_event" do
      get :new, params: {}, session: valid_session
      expect(assigns(:collecting_event)).to be_a_new(CollectingEvent)
    end
  end

  describe "GET edit" do
    it "assigns the requested collecting_event as @collecting_event" do
      collecting_event = CollectingEvent.create! valid_attributes
      get :edit, params: {:id => collecting_event.to_param}, session: valid_session
      expect(assigns(:collecting_event)).to eq(collecting_event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CollectingEvent" do
        expect {
          post :create, params: {:collecting_event => valid_attributes}, session: valid_session
        }.to change(CollectingEvent, :count).by(1)
      end

      it "assigns a newly created collecting_event as @collecting_event" do
        post :create, params: {:collecting_event => valid_attributes}, session: valid_session
        expect(assigns(:collecting_event)).to be_a(CollectingEvent)
        expect(assigns(:collecting_event)).to be_persisted
      end

      it "redirects to the created collecting_event" do
        post :create, params: {:collecting_event => valid_attributes}, session: valid_session
        expect(response).to redirect_to(CollectingEvent.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved collecting_event as @collecting_event" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CollectingEvent).to receive(:save).and_return(false)
        post :create, params: {:collecting_event => {"verbatim_label" => "invalid value"}}, session: valid_session
        expect(assigns(:collecting_event)).to be_a_new(CollectingEvent)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CollectingEvent).to receive(:save).and_return(false)
        post :create, params: {:collecting_event => {"verbatim_label" => "invalid value"}}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested collecting_event" do
        collecting_event = CollectingEvent.create! valid_attributes
        # Assuming there are no other collecting_events in the database, this
        # specifies that the CollectingEvent created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(CollectingEvent).to receive(:update).with({"verbatim_label" => "MyText"})
        put :update, params: {:id => collecting_event.to_param, :collecting_event => {"verbatim_label" => "MyText"}}, session: valid_session
      end

      it "assigns the requested collecting_event as @collecting_event" do
        collecting_event = CollectingEvent.create! valid_attributes
        put :update, params: {:id => collecting_event.to_param, :collecting_event => valid_attributes}, session: valid_session
        expect(assigns(:collecting_event)).to eq(collecting_event)
      end

      it "redirects to the collecting_event" do
        collecting_event = CollectingEvent.create! valid_attributes
        put :update, params: {:id => collecting_event.to_param, :collecting_event => valid_attributes}, session: valid_session
        expect(response).to redirect_to(collecting_event)
      end
    end

    describe "with invalid params" do
      it "assigns the collecting_event as @collecting_event" do
        collecting_event = CollectingEvent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CollectingEvent).to receive(:save).and_return(false)
        put :update, params: {:id => collecting_event.to_param, :collecting_event => {"verbatim_label" => "invalid value"}}, session: valid_session
        expect(assigns(:collecting_event)).to eq(collecting_event)
      end

      it "re-renders the 'edit' template" do
        collecting_event = CollectingEvent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(CollectingEvent).to receive(:save).and_return(false)
        put :update, params: {:id => collecting_event.to_param, :collecting_event => {"verbatim_label" => "invalid value"}}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested collecting_event" do
      collecting_event = CollectingEvent.create! valid_attributes
      expect {
        delete :destroy, params: {:id => collecting_event.to_param}, session: valid_session
      }.to change(CollectingEvent, :count).by(-1)
    end

    it "redirects to the collecting_events list" do
      collecting_event = CollectingEvent.create! valid_attributes
      delete :destroy, params: {:id => collecting_event.to_param}, session: valid_session
      expect(response).to redirect_to(collecting_events_url)
    end
  end

end
