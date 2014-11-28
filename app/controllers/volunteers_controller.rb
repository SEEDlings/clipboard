 class VolunteersController < ApplicationController
  before_action :client

  def new

  end

  def testaction
  # this code checks sf to see if a contact exists then updates it
      @volunteer = Volunteer.new
      @firstname = 'Terry'
      @lastname = 'Gilliam'
      @email = 'terry@montypython.org'
      @existing_records = []
      @matching_names = []
      @existing = @client.query("select Id from contact where email = '#{@email}'")
      @existing.current_page.each do |o|
        @existing_records << o.Id
    end
    @existing_records.each do |o|
      @matching_names << client.find('Contact', "#{o}")
    end
      if @matching_names.empty?
        @client.create!('Contact', FirstName: @firststname, LastName: @lastname, Email: @email )
      else
        puts 'We already have someone in the database with that email'
      end
    end
  end




