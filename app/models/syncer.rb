class Syncer < ActiveRecord::Base

  def syncup(client)
    volunteers = []
    shifts = []
    details = []

    updated_contacts = client.query(
        "SELECT Id, FirstName, LastName, Email
        FROM Contact
        WHERE SystemModstamp > #{self.last_sync}")
    updated_shifts = client.query(
        "SELECT Id, Name, Volunteer_Name__c, Month_Calendar__c, Year__c, Shift_Status__c, Work_in_the_Gardens__c, Morning_Shift__c, Afternoon_Shift__c, Be_a_Guest_Chef__c, Guest_Chef_Shift__c, Volunteer_with_DIG__c, DIG_Shift__c
        FROM SEEDS_Volunteer_Shifts__c
        WHERE SystemModstamp > #{self.last_sync}")
    updated_details = client.query(
        "SELECT Id, Shift__c, Shift_Name__c, Date_Text__c, Date_Calendar__c, Shift_Hours__c
        FROM SEEDS_Vol_Shift_Detail__c
        WHERE SystemModstamp > #{self.last_sync}")

    updated_contacts.current_page.each do |o|
      volunteers << {sf_contact_id: o.Id,
                     name_first: o.FirstName,
                     name_last: o.LastName,
                     email: o.Email}
    end
    updated_shifts.current_page.each do |o|
      # logic to turn job type bools into a Activity
      shifts << {sf_volunteer_shift_id: o.Id,
                 sf_contact_id: o.Volunteer_Name__c,
                 status: o.Shift_Status__c}
    end
    updated_details.current_page.each do |o|
      details << {sf_shift_detail_id: o.Id,
                  sf_volunteer_shift_id: o.Shift__c,
                  shift_name: o.Shift_Name__c,
                  date: o.Date_Text__c,
                  # may need to be changed to date - calendar, etc.
                  hours: o.Shift_Hours__c}
    end

    volunteers.each do |sf_v|
      if Volunteer.any? { |e_v| e_v.sf_id == sf_v[:sf_contact_id] }
        puts "Existing Volunteer found, updating #{sf_v[:sf_contact_id]} #{sf_v[:name_first]} #{sf_v[:name_last]}"
        updated_volunteer = Volunteer.find_by(sf_contact_id: sf_v[:sf_contact_id])
        updated_volunteer.update!(sf_v)
        puts "#{updated_volunteer.name_first} was updated."
      else
        puts "No existing Volunteer found, creating Volunteer #{sf_v[:sf_contact_id]} #{sf_v[:name_first]} #{sf_v[:name_last]}"
        Volunteer.create!(sf_contact_id: sf_v[:sf_contact_id],
                          name_first: sf_v[:name_first],
                          name_last: sf_v[:name_last],
                          email: sf_v[:email])
        puts "Created"
      end
    end

    shifts.each do |sf_s|
      # If there are any (COULD BE MULTIPLE) shifts with the same sf_volunteer_shift_id
      # update the status
      if Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_s[:sf_volunteer_shift_id] }
        puts "Existing Shift(s) found, updating from Volunteer Shift #{sf_s[:sf_volunteer_shift_id]}"
        updated_shifts = Shift.where(sf_volunteer_shift_id: sf_s[:sf_volunteer_shift_id])
        updated_shifts.each {|s| s.update!(status: sf_s[:status]) }
        puts "status updated"
        # !!! remove when status is moved to detail instead of vol shift
      else
        puts "No existing Shift found, creating Shift #{sf_s[:sf_volunteer_shift_id]}"
        Shift.create!(sf_volunteer_shift_id: sf_s[:sf_volunteer_shift_id],
                      sf_shift_detail_id: "pending detail",
                      sf_contact_id: sf_s[:sf_contact_id],
                      volunteer_id: Volunteer.find_by(sf_contact_id: sf_s[:sf_contact_id]).id,
                      activity_id: "pending activity logic",
                      # give activity_id when that logic is in place
                      date: "pending detail",
                      hours: "pending detail",
                      shift_name: "pending detail",
                      status: sf_s[:status] )
        puts "Created"
      end
    end

    details.each do |sf_d|
      # If there is an existing shift with both the same "sf_volunteer_shift_id" AND "sf_shift_detail_id"
      if Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_d[:sf_volunteer_shift_id] && e_s.sf_shift_detail_id == sf_d[:sf_shift_detail_id]}
        puts "Existing Shift found, updating from Shift Detail #{sf_d[:sf_shift_detail_id]}"
        updated_shift = Shift.find_by(sf_shift_detail_id: sf_d[:sf_shift_detail_id])
        updated_shift.update!(sf_d)
        puts "#{updated_shift.sf_shift_detail_id} was updated"

        # If there is an existing shift with the same "sf_volunteer_shift_id", and "sf_shift_detail_id" is "pending detail"
        # update it with the detail info
      elsif Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_d[:sf_volunteer_shift_id] && e_s.sf_shift_detail_id == "pending detail"}
        puts "Shift pending detail found, filling in pending info with Shift Detail #{sf_d[:sf_shift_detail_id]}"
        partial_shift = Shift.find_by(sf_volunteer_shift_id: sf_d[:sf_volunteer_shift_id])
        partial_shift.update!(sf_d)
        puts "Pending Shift #{partial_shift.sf_shift_detail_id} was completed with detail info"

        # If there is an existing shift with the same "sf_volunteer_shift_id", and "sf_shift_detail_id" is NOT "pending detail" OR nil
        # create a new Shift with the same "sf_volunteer_shift_id" info, and the new detail info
      elsif Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_d[:sf_volunteer_shift_id] && e_s.sf_shift_detail_id != "pending detail" && e_s.sf_shift_detail_id != nil}
        companion_shift = Shift.find_by(sf_volunteer_shift_id: sf_d[:sf_volunteer_shift_id])
        Shift.create!(sf_volunteer_shift_id: companion_shift[:sf_volunteer_shift_id],
                      sf_shift_detail_id: sf_d[:sf_shift_detail_id],
                      sf_contact_id: companion_shift[:sf_contact_id],
                      volunteer_id: companion_shift[:volunteer_id],
                      activity_id: "pending activity logic",
                      date: sf_d[:date],
                      # might need to be changed to date - calendar
                      hours: sf_d[:hours],
                      shift_name: sf_d[:shift_name],
                      status: companion_shift[:status]
        # will be updating status from detail here in future
        )
      else
        puts "#{sf_d[:sf_shift_detail_id]} is a Rogue Detail without associated Volunteer Shift!"
      end
    end
    self.update!(last_sync: DateTime.now.utc.iso8601)
  end

  def full_sync
    # as above, without conditional(s)(?)
  end
end
