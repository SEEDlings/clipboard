class HomeController < ApplicationController
  before_action :set_client

  def index
    return unless logged_in?
  end

  private

  def set_client
    return unless logged_in?
    salesforce_auth = current_user.authorizations.find_by(provider: 'salesforce')
    return unless salesforce_auth
    binding.pry
    client = Restforce.new :host => ENV['SALESFORCE_HOST'],
      :oauth_token   => salesforce_auth.oauth_token,
      :refresh_token => salesforce_auth.refresh_token,
      :instance_url  => ENV['SALESFORCE_HOST'],
      :client_id     => ENV['SALESFORCE_KEY'],
      :client_secret => ENV['SALESFORCE_SECRET']
    end
end
