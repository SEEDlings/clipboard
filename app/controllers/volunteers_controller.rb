class VolunteersController < ApplicationController
  before_action :client

  def new
    @volunteer = Volunteer.new
  end

  def testaction
    #needs to look at form to obtain params
    @firstname = testaction_params[:name_first]
    @lastname = testaction_params[:name_last]
    @email = testaction_params[:email]
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
      sf_id = @client.create!('Contact', FirstName: testaction_params[:name_first], LastName: testaction_params[:name_last], Email: testaction_params[:email] )
      Volunteer.find_or_create_by!(email: testaction_params[:email]) do |volunteer|
        volunteer.name_first = testaction_params[:name_first]
        volunteer.name_last = testaction_params[:name_last]
        volunteer.sf_contact_id = sf_id
      end
    else
      sf_id = @matching_names[0][:Id]
      puts 'We already have someone in the database with that email'
    end
    sf_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, Shift_Status__c: "Confirmed" )
    @client.create!('SEEDS_Vol_Shift_Detail__c', Shift__c: sf_shift_id, Shift_Hours__c: 3.00, Date_Text__c: Date.today.strftime("%A %B %d"))
    Shift.find_or_create_by!(sf_volunteer_shift_id: sf_id ) do |shift|
      shift.sf_contact_id = sf_id
      shift.date = Date.today.to_s
      shift.hours = 3.00
      shift.status = "Confirmed"
      shift.year = Time.now.year
    end

  end

  private

  def testaction_params
    params.require(:volunteer).permit(:name_first, :name_last, :email)
  end
end




