class HomeController < ApplicationController
  before_action :client

  def index
    return unless logged_in?
    @volunteer = Volunteer.new
  end

  Syncer.find_by(id: 1).syncup(@client)
  
end

private

end
