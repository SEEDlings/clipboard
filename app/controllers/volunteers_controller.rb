class VolunteersController < ApplicationController
  before_action :client

  def new
    @volunteer = Volunteer.new
  end

  def sfcreate
    #needs to look at form to obtain params
    @existing_records = []
    @matching_names = []
    @existing = @client.query("select Id from contact where email = '#{sfcreate_params[:email]}'")
    @existing.current_page.each do |o|
      @existing_records << o.Id
    end

    if @existing_records.empty?
      sf_id = @client.create!('Contact', FirstName: sfcreate_params[:name_first], LastName: sfcreate_params[:name_last], Email: sfcreate_params[:email] )
      Volunteer.find_or_create_by!(email: sfcreate_params[:email]) do |volunteer|
        volunteer.name_first = sfcreate_params[:name_first]
        volunteer.name_last = sfcreate_params[:name_last]
        volunteer.sf_contact_id = sf_id
        flash[:notice] = "#{sfcreate_params[:name_first]} added as a new contact. Shift created and confirmed in Salesforce."
      end
    else
      sf_id = @existing_records[0]
      puts 'We already have someone in the database with that email'
      flash[:notice] = "Created and confirmed shift for #{sfcreate_params[:name_first]} in Salesforce."
    end

    if params[:shift_type] == 'Garden Morning'
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c',
                                              Volunteer_Name__c: sf_id,
                                              Year__c: Time.now.year,
                                              ShiftType__c: params[:shift_type],
                                              Morning_Shift_Date__c: Date.today.strftime("%A %B %d"),
                                              Hours__c: 3.00,
                                              Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Garden Afternoon'
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c',
                                              Volunteer_Name__c: sf_id,
                                              Year__c: Time.now.year,
                                              ShiftType__c: params[:shift_type],
                                              Afternoon_Shift_Date__c: Date.today.strftime("%A %B %d"),
                                              Hours__c: 3.00,
                                              Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'DIG'
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type],  DIG_Shift__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Guest Chef'
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type], Guest_Chef_Shift__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Admin/Office'
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type], Date_Text__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    else
      sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type],  Date_Text__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )
    end

    @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{sf_volunteer_shift_id}", Shift_Status__c: "Confirmed")

    new_shift = Shift.find_or_create_by!(sf_volunteer_shift_id: sf_volunteer_shift_id ) do |shift|
      shift.sf_contact_id = sf_id
      shift.date = Date.today.to_s
      shift.shift_type = params[:shift_type]
      shift.hours = 3.00
      shift.status = "Confirmed"
      shift.year = Time.now.year
      shift.sf_volunteer_shift_id = sf_volunteer_shift_id
      shift.volunteer = Volunteer.find_by(sf_contact_id: sf_id)

    end

    redirect_to root_path
  end
end

private

def sfcreate_params
  params.require(:volunteer).permit(:name_first, :name_last, :email)
end
