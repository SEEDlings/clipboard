class HomeController < ApplicationController
  before_action :client

  def index
    return unless logged_in?
  end

  def sync
    Syncer.find_by(id: 1).syncup(@client)
  end

  private

end
