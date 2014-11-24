class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :current_user=, :client

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def current_user=(user)
    @current_user = user
    if @current_user
      session[:current_user_id] = user.id
    else
      session[:current_user_id] = nil
    end
  end

  def logged_in?
    current_user
  end

  def client
    return unless logged_in?
    salesforce_auth = current_user.authorizations.find_by(provider: 'salesforcesandbox')
    return unless salesforce_auth
    @client = Restforce.new :host => ENV['SALESFORCE_SANDBOX_HOST'],
                            :oauth_token   => salesforce_auth.oauth_token,
                            :refresh_token => salesforce_auth.refresh_token,
                            :instance_url  => ENV['SALESFORCE_SANDBOX_URL'],
                            :client_id     => ENV['SALESFORCE_SANDBOX_KEY'],
                            :client_secret => ENV['SALESFORCE_SANDBOX_SECRET']
  end
end
