  class VolunteersController < ApplicationController
    before_action :client

    def new
      @volunteer = Volunteer.new
    end

    def sfcreate
      #needs to look at form to obtain params
      @firstname = sfcreate_params[:name_first]
      @lastname = sfcreate_params[:name_last]
      @email = sfcreate_params[:email]
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
        sf_id = @client.create!('Contact', FirstName: sfcreate_params[:name_first], LastName: sfcreate_params[:name_last], Email: sfcreate_params[:email] )
        Volunteer.find_or_create_by!(email: sfcreate_params[:email]) do |volunteer|
          volunteer.name_first = sfcreate_params[:name_first]
          volunteer.name_last = sfcreate_params[:name_last]
          volunteer.sf_contact_id = sf_id
        end

      else
        sf_id = @matching_names[0][:Id]
        puts 'We already have someone in the database with that email'
      end

    if params[:shift_type] == 'Garden Morning'
        sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type],  Morning_Shift_Date__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Garden Afternoon'
    sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type],  Afternoon_Shift_Date__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'DIG'
    sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type],  DIG_Shift__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Guest Chef'
    sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type], Guest_Chef_Shift__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

    elsif params[:shift_type] == 'Admin/Office'
    sf_volunteer_shift_id = @client.create!('SEEDS_Volunteer_Shifts__c', Volunteer_Name__c: sf_id, Year__c: Time.now.year, ShiftType__c: params[:shift_type], Date_Text__c: Date.today.strftime("%A %B %d"), Hours__c: 3.00, Shift_Status__c: "Confirmed" )

  end

  new_shift = Shift.find_or_create_by!(sf_volunteer_shift_id: sf_volunteer_shift_id ) do |shift|
    shift.sf_contact_id = sf_id
    shift.date = Date.today.to_s
    shift.shift_type = params[:shift_type]
    shift.hours = 3.00
    shift.status = "Confirmed"
    shift.year = Time.now.year
    shift.sf_volunteer_shift_id = sf_volunteer_shift_id
    shift.volunteer = Volunteer.find_by(sf_contact_id: sf_id)
    redirect_to root_path
    end
  end
end
  private

  def sfcreate_params
    params.require(:volunteer).permit(:name_first, :name_last, :email)
  end

