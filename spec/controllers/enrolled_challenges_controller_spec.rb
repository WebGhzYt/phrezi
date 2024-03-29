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

describe EnrolledChallengesController do

  # This should return the minimal set of attributes required to create a valid
  # EnrolledChallenge. As you add validations to EnrolledChallenge, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "challenge" => "" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # EnrolledChallengesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all enrolled_challenges as @enrolled_challenges" do
      enrolled_challenge = EnrolledChallenge.create! valid_attributes
      get :index, {}, valid_session
      assigns(:enrolled_challenges).should eq([enrolled_challenge])
    end
  end

  describe "GET show" do
    it "assigns the requested enrolled_challenge as @enrolled_challenge" do
      enrolled_challenge = EnrolledChallenge.create! valid_attributes
      get :show, {:id => enrolled_challenge.to_param}, valid_session
      assigns(:enrolled_challenge).should eq(enrolled_challenge)
    end
  end

  describe "GET new" do
    it "assigns a new enrolled_challenge as @enrolled_challenge" do
      get :new, {}, valid_session
      assigns(:enrolled_challenge).should be_a_new(EnrolledChallenge)
    end
  end

  describe "GET edit" do
    it "assigns the requested enrolled_challenge as @enrolled_challenge" do
      enrolled_challenge = EnrolledChallenge.create! valid_attributes
      get :edit, {:id => enrolled_challenge.to_param}, valid_session
      assigns(:enrolled_challenge).should eq(enrolled_challenge)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new EnrolledChallenge" do
        expect {
          post :create, {:enrolled_challenge => valid_attributes}, valid_session
        }.to change(EnrolledChallenge, :count).by(1)
      end

      it "assigns a newly created enrolled_challenge as @enrolled_challenge" do
        post :create, {:enrolled_challenge => valid_attributes}, valid_session
        assigns(:enrolled_challenge).should be_a(EnrolledChallenge)
        assigns(:enrolled_challenge).should be_persisted
      end

      it "redirects to the created enrolled_challenge" do
        post :create, {:enrolled_challenge => valid_attributes}, valid_session
        response.should redirect_to(EnrolledChallenge.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved enrolled_challenge as @enrolled_challenge" do
        # Trigger the behavior that occurs when invalid params are submitted
        EnrolledChallenge.any_instance.stub(:save).and_return(false)
        post :create, {:enrolled_challenge => { "challenge" => "invalid value" }}, valid_session
        assigns(:enrolled_challenge).should be_a_new(EnrolledChallenge)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        EnrolledChallenge.any_instance.stub(:save).and_return(false)
        post :create, {:enrolled_challenge => { "challenge" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested enrolled_challenge" do
        enrolled_challenge = EnrolledChallenge.create! valid_attributes
        # Assuming there are no other enrolled_challenges in the database, this
        # specifies that the EnrolledChallenge created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        EnrolledChallenge.any_instance.should_receive(:update).with({ "challenge" => "" })
        put :update, {:id => enrolled_challenge.to_param, :enrolled_challenge => { "challenge" => "" }}, valid_session
      end

      it "assigns the requested enrolled_challenge as @enrolled_challenge" do
        enrolled_challenge = EnrolledChallenge.create! valid_attributes
        put :update, {:id => enrolled_challenge.to_param, :enrolled_challenge => valid_attributes}, valid_session
        assigns(:enrolled_challenge).should eq(enrolled_challenge)
      end

      it "redirects to the enrolled_challenge" do
        enrolled_challenge = EnrolledChallenge.create! valid_attributes
        put :update, {:id => enrolled_challenge.to_param, :enrolled_challenge => valid_attributes}, valid_session
        response.should redirect_to(enrolled_challenge)
      end
    end

    describe "with invalid params" do
      it "assigns the enrolled_challenge as @enrolled_challenge" do
        enrolled_challenge = EnrolledChallenge.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EnrolledChallenge.any_instance.stub(:save).and_return(false)
        put :update, {:id => enrolled_challenge.to_param, :enrolled_challenge => { "challenge" => "invalid value" }}, valid_session
        assigns(:enrolled_challenge).should eq(enrolled_challenge)
      end

      it "re-renders the 'edit' template" do
        enrolled_challenge = EnrolledChallenge.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        EnrolledChallenge.any_instance.stub(:save).and_return(false)
        put :update, {:id => enrolled_challenge.to_param, :enrolled_challenge => { "challenge" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested enrolled_challenge" do
      enrolled_challenge = EnrolledChallenge.create! valid_attributes
      expect {
        delete :destroy, {:id => enrolled_challenge.to_param}, valid_session
      }.to change(EnrolledChallenge, :count).by(-1)
    end

    it "redirects to the enrolled_challenges list" do
      enrolled_challenge = EnrolledChallenge.create! valid_attributes
      delete :destroy, {:id => enrolled_challenge.to_param}, valid_session
      response.should redirect_to(enrolled_challenges_url)
    end
  end

end
