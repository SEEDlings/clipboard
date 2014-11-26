class VolunteersController < ApplicationController
  before_action :client

  def index
    @volunteer = Volunteers.new
  end

  def testaction
  end
end
