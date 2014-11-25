class VolunteersController < ApplicationController
  before_action :client

    def testaction
      result = client.query("select Id from contact where LastModifiedDate < #{DateTime.now}")
      puts result.current_page
      binding.pry
    end
end
