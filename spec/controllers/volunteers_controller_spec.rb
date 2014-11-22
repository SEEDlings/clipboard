require 'rails_helper'

RSpec.describe VolunteersController, :type => :controller do

  describe "GET testaction" do
    it "returns http success" do
      get :testaction
      expect(response).to have_http_status(:success)
    end
  end

end
