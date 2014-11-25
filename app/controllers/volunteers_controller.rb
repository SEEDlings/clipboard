class VolunteersController < ApplicationController
  before_action :client

  def testaction
    names = []

    updated = client.query("SELECT Id, FirstName FROM Contact WHERE SystemModstamp < #{DateTime.now}")
    updated.current_page.each do |o|
      names << o.FirstName
    end

    puts names

  end
end
