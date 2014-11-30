require 'rails_helper'

RSpec.describe VolunteersController, :type => :controller do

  describe "GET sfcreate" do
    it "returns http success" do
      get :sfcreate
      expect(response).to have_http_status(:success)
    end
  end

end
