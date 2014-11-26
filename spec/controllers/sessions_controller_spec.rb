require 'rails_helper'
require 'spec_helper'

RSpec.describe SessionsController, :type => :controller do

    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:salesforce]
    end

    describe "#create" do

      it "should successfully find or create a user" do
        expect {
          post :create, provider: :salesforce
        }.to change{ User.count }.by(1)
      end

      # it "should successfully create a session" do
      #   session[:user_id].should be_nil
      #   post :create, provider: :salesforce
      #   session[:user_id].should_not be_nil
      # end

      # it "should redirect the user to the root url" do
      #   post :create, provider: :salesforce
      #   response.expect redirect_to root_url
      # end

    end

    describe "#destroy" do
      before do
        post :create, provider: :salesforce
      end

      # it "should clear the session" do
      #   session[:user_id].should_not be_nil
      #   delete :destroy
      #   session[:user_id].should be_nil
      # end

      # it "should redirect to the home page" do
      #   delete :destroy
      #   response.expect redirect_to root_url
      # end
    end

  end

