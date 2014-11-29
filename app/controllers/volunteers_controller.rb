 class VolunteersController < ApplicationController
  before_action :client

  def new

  end

  def testaction
    #needs to look at form to obtain params
      @firstname = params[:walkin][:name_first]
      @lastname = params[:walkin][:name_last]
      @email = params[:walkin][:name_last]
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




