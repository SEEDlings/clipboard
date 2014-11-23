class VolunteersController < ApplicationController
  before_action :client

  def testaction
    puts client.search('FIND {david}')
  end
end
