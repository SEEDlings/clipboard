class HomeController < ApplicationController
  before_action :client

def index
  return unless logged_in?
  Syncer.find_by(id: 1).syncup(@client)
end

def sync
  Syncer.find_by(id: 1).syncup(@client)
end

private

end
