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

describe PeopleController, :type => :controller do
  before(:each) {
    sign_in
  }

  # This should return the minimal set of attributes required to create a valid
  # Georeference. As you add validations to Georeference be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    strip_housekeeping_attributes(FactoryGirl.build(:valid_person).attributes)
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PeopleController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all people as @people" do
      person = Person.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:people).to_a).to include(person.becomes(Person::Unvetted))
    end
  end

  describe "GET show" do
    it "assigns the requested person as @person" do
      person = Person.create! valid_attributes
      get :show, params: {:id => person.to_param}, session: valid_session
      expect(assigns(:person)).to eq(person.becomes(Person::Unvetted))
    end
  end

  describe "GET new" do
    it "assigns a new person as @person" do
      get :new, params: {}, session: valid_session
      expect(assigns(:person)).to be_a_new(Person)
    end
  end

  describe "GET edit" do
    it "assigns the requested person as @person" do
      person = Person.create! valid_attributes
      get :edit, params: {:id => person.to_param}, session: valid_session
      expect(assigns(:person)).to eq(person.becomes(Person::Unvetted))
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Person" do
        expect {
          post :create, params: {:person => valid_attributes}, session: valid_session
        }.to change(Person::Unvetted, :count).by(1)
      end

      it "assigns a newly created person as @person" do
        post :create, params: {:person => valid_attributes}, session: valid_session
        expect(assigns(:person)).to be_a(Person)
        expect(assigns(:person)).to be_persisted
      end

      it "redirects to the created person" do
        post :create, params: {:person => valid_attributes}, session: valid_session
        expect(response).to redirect_to(Person.last.becomes(Person))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved person as @person" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Person).to receive(:save).and_return(false)
        post :create, params: {:person => {last_name: nil}}, session: valid_session
        expect(assigns(:person)).to be_a_new(Person)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Person).to receive(:save).and_return(false)
        post :create, params: {:person => {last_name: nil}}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested person" do
        person = Person.create! valid_attributes
        # Assuming there are no other people in the database, this
        # specifies that the Person created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Person).to receive(:update).with({"type" => ""})
        put :update, params: {:id => person.to_param, :person => {"type" => ""}}, session: valid_session
      end

      it "assigns the requested person as @person" do
        person = Person.create! valid_attributes
        put :update, params: {:id => person.to_param, :person => valid_attributes}, session: valid_session
        expect(assigns(:person)).to eq(person.becomes(Person::Unvetted))
      end

      it "redirects to the person" do
        person = Person.create! valid_attributes
        put :update, params: {:id => person.to_param, :person => valid_attributes}, session: valid_session
        expect(response).to redirect_to(person.becomes(Person))
      end
    end

    describe "with invalid params" do
      it "assigns the person as @person" do
        person = Person.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Person).to receive(:save).and_return(false)
        put :update, params: {:id => person.to_param, :person => {"type" => "invalid value"}}, session: valid_session
        expect(assigns(:person)).to eq(person.becomes(Person::Unvetted))
      end

      it "re-renders the 'edit' template" do
        person = Person.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Person).to receive(:save).and_return(false)
        put :update, params: {:id => person.to_param, :person => {"type" => "invalid value"}}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested person" do
      person = Person.create! valid_attributes
      expect {
        delete :destroy, params: {:id => person.to_param}, session: valid_session
      }.to change(Person, :count).by(-1)
    end

    it "redirects to the people list" do
      person = Person.create! valid_attributes
      delete :destroy, params: {:id => person.to_param}, session: valid_session
      expect(response).to redirect_to(people_url)
    end
  end

end
