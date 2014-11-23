class HomeController < ApplicationController
  before_action :client

  def index
    return unless logged_in?
  end

  private


end
