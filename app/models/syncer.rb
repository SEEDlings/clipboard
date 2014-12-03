class Syncer < ActiveRecord::Base

  def syncup(client)
    volunteers = []
    shifts = []

    updated_contacts = client.query(
        "SELECT Id, FirstName, LastName, Email
        FROM Contact
        WHERE SystemModstamp > #{self.last_sync}")
    updated_shifts = client.query(
        "SELECT Id, Name, Volunteer_Name__c, ShiftType__c, Date_Text__c, Year__c, Hours__c, Shift_Status__c, Morning_Shift_Date__c, Afternoon_Shift_Date__c, Guest_Chef_Shift__c, DIG_Shift__c, Special_Needs_Allergies__c
        FROM SEEDS_Volunteer_Shifts__c
        WHERE SystemModstamp > #{self.last_sync}")

    updated_contacts.current_page.each do |o|
      volunteers << {sf_contact_id: o.Id,
                     name_first: o.FirstName,
                     name_last: o.LastName,
                     email: o.Email}
    end
    updated_shifts.current_page.each do |o|
      shifts << { sf_volunteer_shift_id: o.Id,
                  shift_name: o.Name,
                  sf_contact_id: o.Volunteer_Name__c,
                  shift_type: o.ShiftType__c,
                  status: o.Shift_Status__c,
                  year: o.Year__c,
                  date: o.Date_Text__c,
                  hours: o.Hours__c,
                  morning_shift: o.Morning_Shift_Date__c,
                  afternoon_shift: o.Afternoon_Shift_Date__c,
                  guest_chef_shift: o.Guest_Chef_Shift__c,
                  dig_shift: o.DIG_Shift__c,
                  notes: o.Special_Needs_Allergies__c }
    end

    volunteers.each do |sf_v|
      if Volunteer.any? { |e_v| e_v.sf_contact_id == sf_v[:sf_contact_id] }
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
        puts "Created Volunteer #{sf_v[:sf_contact_id]}"
      end
    end

    shifts.each do |sf_s|
      # If there is a Shift with the same sf_volunteer_shift_id
      # update the status
      if Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_s[:sf_volunteer_shift_id] }
        puts "Existing Shift(s) found, updating from Volunteer Shift #{sf_s[:sf_volunteer_shift_id]}"
        updated_shift = Shift.where(sf_volunteer_shift_id: sf_s[:sf_volunteer_shift_id])[0]
        updated_shift.update!(shift_type: sf_s[:shift_type])
        updated_shift.update!(status: sf_s[:status])
        updated_shift.update!(year: sf_s[:year])
        updated_shift.update!(hours: sf_s[:hours])
        updated_shift.update!(date: "pending parse")
        if sf_s[:guest_chef_shift] != nil
          date = Chronic.parse(sf_s[:guest_chef_shift]).to_date
        elsif sf_s[:dig_shift] != nil
          date = Chronic.parse(sf_s[:dig_shift]).to_date
        elsif sf_s[:date] != nil
          date = Chronic.parse(sf_s[:date]).to_date
        elsif sf_s[:morning_shift] != nil
          date = Chronic.parse(sf_s[:morning_shift]).to_date
        elsif sf_s[:afternoon_shift] != nil
          date = Chronic.parse(sf_s[:afternoon_shift]).to_date
          end
        updated_shift.update!(date: date)
        puts "Updated Shift #{sf_s[:sf_volunteer_shift_id]}"

      else
        puts "No existing Shift found, creating Shift #{sf_s[:sf_volunteer_shift_id]}"
        new_shift = Shift.create!(sf_volunteer_shift_id: sf_s[:sf_volunteer_shift_id],
                                  shift_name: sf_s[:shift_name],
                                  sf_contact_id: sf_s[:sf_contact_id],
                                  volunteer_id: Volunteer.find_by(sf_contact_id: sf_s[:sf_contact_id]).id,
                                  shift_type: sf_s[:shift_type],
                                  status: sf_s[:status],
                                  year: sf_s[:year],
                                  date: "pending parse",
                                  hours: sf_s[:hours])

        # add date from a shift type field in this priority...
        if sf_s[:guest_chef_shift] != nil
          date = Chronic.parse(sf_s[:guest_chef_shift]).to_date
        elsif sf_s[:dig_shift] != nil
          date = Chronic.parse(sf_s[:dig_shift]).to_date
        elsif sf_s[:date] != nil
          date = Chronic.parse(sf_s[:date]).to_date
        elsif sf_s[:morning_shift] != nil
          date = Chronic.parse(sf_s[:morning_shift]).to_date
        elsif sf_s[:afternoon_shift] != nil
          date = Chronic.parse(sf_s[:afternoon_shift]).to_date
        end
        new_shift.update!(date: date)
        puts "Created"
      end
    end

    self.update!(last_sync: DateTime.now.utc.iso8601)
  end

  def update_no_shows(client)
    sign_ups = Shift.where(status: "Sign Up")
    sign_ups.each do |su|
      if su.date.to_date < Date.today
        puts "Expired Sign Up found for #{su.sf_volunteer_shift_id}, changing to No Show"
        if client.update!('SEEDS_Volunteer_Shifts__c',
                           Id: "#{su.sf_volunteer_shift_id}",
                           Shift_Status__c: "No Show")
          Shift.find_by(sf_volunteer_shift_id: su.sf_volunteer_shift_id).update!(status: 'No Show')
          puts "Updated Shift #{su.sf_volunteer_shift_id} status to No Show"
        end
      end
    end
  end
end
