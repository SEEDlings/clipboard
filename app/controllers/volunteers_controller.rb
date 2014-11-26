class VolunteersController < ApplicationController
  before_action :client

  def index
    @volunteer = Volunteers.new

  end


  def testaction
    updated_ids = []
    updated_records = []
    updated = client.query("select Id from contact where SystemModstamp < #{DateTime.now}")
    updated.current_page.each do |o|
      updated_ids << o.Id
    end
    updated_ids.each do |o|
      updated_records << client.find('Contact', "#{o}")
    end
    updated_records.each do |o|
      puts o.FirstName
    end
  end
end
