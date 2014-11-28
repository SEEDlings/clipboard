class VolunteersController < ApplicationController
  before_action :client

def testaction
# this code checks sf to see if a contact exists then updates it
  @lastname = 'Palin'
  @firstname = 'Michael'
  @email = 'michael@montypython.org'
  @existing_records = []
  @matching_names = []
  @existing = @client.query("select Id from contact where Email = '@email'")
  @existing.current_page.each do |o|
    @existing_records << o.Id
  end
  @existing_records.each do |o|
    @matching_names << client.find('Contact', "#{o}")
  end
  @matching_names.each do |o|
    puts o.FirstName
  end
  @matching_names.nil?
  @client.create!('Contact', FirstName: @firststname, LastName: @lastname, Email: @email )
end
end




