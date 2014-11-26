class VolunteersController < ApplicationController
  before_action :client


# def testaction
#   @shifts = @client.query("select Id from SEEDS_Volunteer_Shifts__c where LastModifiedDate < #{DateTime.now}")
#   @status = @client.find("SEEDS_Volunteer_Shifts__c" , "a0bq00000000A1ZAAU")
#   @client.update!('SEEDS_Volunteer_Shifts__c', Id: "a0bq00000000A1ZAAU", Shift_Status__c: "Confirmed")
#   puts @shifts
# end
# this code checks sf to see if a contact exists then updates it
#   @lastname = 'Cleese'
#   @firstname = 'John'
#   @existing_records = []
#   @matching_names = []
#   @existing = @client.query("select Id from contact where LastName = '#{@lastname}'")
#   @existing.current_page.each do |o|
#     @existing_records << o.Id
#   end
#   @existing_records.each do |o|
#     @matching_names << client.find('Contact', "#{o}")
#   end
#   @matching_names.each do |o|
#     puts o.FirstName
#   end
#   @matching_names.nil?
#   @client.create!('Contact', FirstName: '#{@firststname}', LastName: '#{@lastname}')
# end
end
  #
  def testaction
  end


