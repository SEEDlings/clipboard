class VolunteersController < ApplicationController
  before_action :client


  def testaction
    last_sync = DateTime.now - 6
    volunteers = []
    shifts = []
    details = []

    updated_contacts = client.query("SELECT Id, FirstName, LastName, Email FROM Contact WHERE SystemModstamp > #{last_sync}")
    updated_shifts = client.query("SELECT Id, Name, Volunteer_Name__c, Month_Calendar__c, Year__c, Shift_Status__c, Work_in_the_Gardens__c, Morning_Shift__c, Afternoon_Shift__c, Be_a_Guest_Chef__c, Guest_Chef_Shift__c, Volunteer_with_DIG__c, DIG_Shift__c FROM SEEDS_Volunteer_Shifts__c WHERE SystemModstamp > #{last_sync}")
    updated_details = client.query("SELECT Id, Shift__c, Shift_Name__c, Date_text__c, Date_Calendar__c, Shift_Hours__c FROM SEEDS_Vol_Shift_Detail__c WHERE SystemModstamp > #{last_sync}")
    updated_contacts.current_page.each do |o|
      volunteers << [sf_id: o.Id, name_first: o.FirstName, name_last: o.LastName, email: o.Email]
    end
    updated_shifts.current_page.each do |o|
      shifts << [sf_volunteer_shift_id: o.Id, contact_name: o.Volunteer_Name__c, status: o.Shift_Status__c]
    end
    updated_details.current_page.each do |o|
      details << [sf_shift_detail_id: o.Id, shift: o.Shift__c, shift_name: o.Shift_Name__c, date_text: o.Date_text__c, date_calendar: o.Date_Calendar__c, hours: o.Shift_Hours__c]
    end

    puts volunteers
    puts shifts
    puts details

  end
end
