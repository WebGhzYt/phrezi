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

describe CheckinBallyhoosController do

  # This should return the minimal set of attributes required to create a valid
  # CheckinBallyhoo. As you add validations to CheckinBallyhoo, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "include_friends" => "false" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CheckinBallyhoosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all checkin_ballyhoos as @checkin_ballyhoos" do
      checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
      get :index, {}, valid_session
      assigns(:checkin_ballyhoos).should eq([checkin_ballyhoo])
    end
  end

  describe "GET show" do
    it "assigns the requested checkin_ballyhoo as @checkin_ballyhoo" do
      checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
      get :show, {:id => checkin_ballyhoo.to_param}, valid_session
      assigns(:checkin_ballyhoo).should eq(checkin_ballyhoo)
    end
  end

  describe "GET new" do
    it "assigns a new checkin_ballyhoo as @checkin_ballyhoo" do
      get :new, {}, valid_session
      assigns(:checkin_ballyhoo).should be_a_new(CheckinBallyhoo)
    end
  end

  describe "GET edit" do
    it "assigns the requested checkin_ballyhoo as @checkin_ballyhoo" do
      checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
      get :edit, {:id => checkin_ballyhoo.to_param}, valid_session
      assigns(:checkin_ballyhoo).should eq(checkin_ballyhoo)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CheckinBallyhoo" do
        expect {
          post :create, {:checkin_ballyhoo => valid_attributes}, valid_session
        }.to change(CheckinBallyhoo, :count).by(1)
      end

      it "assigns a newly created checkin_ballyhoo as @checkin_ballyhoo" do
        post :create, {:checkin_ballyhoo => valid_attributes}, valid_session
        assigns(:checkin_ballyhoo).should be_a(CheckinBallyhoo)
        assigns(:checkin_ballyhoo).should be_persisted
      end

      it "redirects to the created checkin_ballyhoo" do
        post :create, {:checkin_ballyhoo => valid_attributes}, valid_session
        response.should redirect_to(CheckinBallyhoo.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved checkin_ballyhoo as @checkin_ballyhoo" do
        # Trigger the behavior that occurs when invalid params are submitted
        CheckinBallyhoo.any_instance.stub(:save).and_return(false)
        post :create, {:checkin_ballyhoo => { "include_friends" => "invalid value" }}, valid_session
        assigns(:checkin_ballyhoo).should be_a_new(CheckinBallyhoo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        CheckinBallyhoo.any_instance.stub(:save).and_return(false)
        post :create, {:checkin_ballyhoo => { "include_friends" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested checkin_ballyhoo" do
        checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
        # Assuming there are no other checkin_ballyhoos in the database, this
        # specifies that the CheckinBallyhoo created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        CheckinBallyhoo.any_instance.should_receive(:update).with({ "include_friends" => "false" })
        put :update, {:id => checkin_ballyhoo.to_param, :checkin_ballyhoo => { "include_friends" => "false" }}, valid_session
      end

      it "assigns the requested checkin_ballyhoo as @checkin_ballyhoo" do
        checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
        put :update, {:id => checkin_ballyhoo.to_param, :checkin_ballyhoo => valid_attributes}, valid_session
        assigns(:checkin_ballyhoo).should eq(checkin_ballyhoo)
      end

      it "redirects to the checkin_ballyhoo" do
        checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
        put :update, {:id => checkin_ballyhoo.to_param, :checkin_ballyhoo => valid_attributes}, valid_session
        response.should redirect_to(checkin_ballyhoo)
      end
    end

    describe "with invalid params" do
      it "assigns the checkin_ballyhoo as @checkin_ballyhoo" do
        checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CheckinBallyhoo.any_instance.stub(:save).and_return(false)
        put :update, {:id => checkin_ballyhoo.to_param, :checkin_ballyhoo => { "include_friends" => "invalid value" }}, valid_session
        assigns(:checkin_ballyhoo).should eq(checkin_ballyhoo)
      end

      it "re-renders the 'edit' template" do
        checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CheckinBallyhoo.any_instance.stub(:save).and_return(false)
        put :update, {:id => checkin_ballyhoo.to_param, :checkin_ballyhoo => { "include_friends" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested checkin_ballyhoo" do
      checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
      expect {
        delete :destroy, {:id => checkin_ballyhoo.to_param}, valid_session
      }.to change(CheckinBallyhoo, :count).by(-1)
    end

    it "redirects to the checkin_ballyhoos list" do
      checkin_ballyhoo = CheckinBallyhoo.create! valid_attributes
      delete :destroy, {:id => checkin_ballyhoo.to_param}, valid_session
      response.should redirect_to(checkin_ballyhoos_url)
    end
  end

end
