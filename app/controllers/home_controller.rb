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
    client = Restforce.new :host => 'ENV[SALESFORCE_HOST]',
      :oauth_token => 'oauth token',
      :refresh_token => 'refresh token',
      :instance_url  => 'https://na17.salesforce.com',
      :client_id     => 'ENV[SALESFORCE_KEY]',
      :client_secret => 'ENV[SALESFORCE_SECRET]'
    end
end
