class VolunteersController < ApplicationController
  before_action :client

  def testaction
    names = []

    updated = client.query("SELECT Id, FirstName, LastName, Email FROM Contact WHERE SystemModstamp > #{DateTime.now - 4}")
    updated.current_page.each do |o|
      names << [sf_id: o.Id, name_first: o.FirstName, name_last: o.LastName, email: o.Email]
    end

    puts names

  end
end
