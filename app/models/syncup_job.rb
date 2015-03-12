class SyncupJob < ActiveRecord::Base
  include SuckerPunch::Job

  def syncup(client)

    ActiveRecord::Base.connection_pool.with_connection do
      Syncer.find_by(id: 1).update!(state: "syncing")
      volunteers = []
      shifts = []
      
      updated_contacts = client.query(
          "SELECT Id, FirstName, LastName, Email
          FROM Contact
          WHERE SystemModstamp > #{Syncer.find_by(id: 1).last_sync}")

      updated_shifts = client.query(
          "SELECT Id, Name, Volunteer_Name__c, ShiftType__c, Date_Text__c, Year__c, Hours__c, Shift_Status__c, Morning_Shift_Date__c, Afternoon_Shift_Date__c, Guest_Chef_Shift__c, DIG_Shift__c, Emerg_Contact_Name__c, Emerg_Contact_Phone__c, Special_Needs_Allergies__c
          FROM SEEDS_Volunteer_Shifts__c
          WHERE SystemModstamp > #{Syncer.find_by(id: 1).last_sync}")

      updated_contacts.each do |o|
        volunteers << { sf_contact_id: o.Id,
                        name_first: o.FirstName,
                        name_last: o.LastName,
                        email: o.Email }
      end

      updated_shifts.each do |o|
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
                    emergency_contact_name: o.Emerg_Contact_Name__c,
                    emergency_contact_phone: o.Emerg_Contact_Phone__c,
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
        if Shift.any? { |e_s| e_s.sf_volunteer_shift_id == sf_s[:sf_volunteer_shift_id] }
          puts "Existing Shift(s) found, updating from Volunteer Shift #{sf_s[:sf_volunteer_shift_id]}"
          updated_shift = Shift.where(sf_volunteer_shift_id: sf_s[:sf_volunteer_shift_id])[0]
          updated_shift.update!(shift_type: sf_s[:shift_type])
          updated_shift.update!(status: sf_s[:status])
          updated_shift.update!(year: sf_s[:year])
          updated_shift.update!(hours: sf_s[:hours])
          updated_shift.update!(date: "pending parse")
          if sf_s[:shift_type]
            if sf_s[:shift_type] == "Guest Chef" && sf_s[:guest_chef_shift] != nil
              parsed_date = Chronic.parse(sf_s[:guest_chef_shift])
            elsif sf_s[:shift_type] =="DIG"  && sf_s[:dig_shift] != nil
              parsed_date = Chronic.parse(sf_s[:dig_shift])
            elsif sf_s[:shift_type] == "Admin/Office" && sf_s[:date] != nil
              parsed_date = Chronic.parse(sf_s[:date])
            elsif sf_s[:shift_type] == "Garden Morning" && sf_s[:morning_shift] != nil
              parsed_date = Chronic.parse(sf_s[:morning_shift])
            elsif sf_s[:shift_type] == "Garden Afternoon" && sf_s[:afternoon_shift] != nil
              parsed_date = Chronic.parse(sf_s[:afternoon_shift])
            end
          else
            if sf_s[:guest_chef_shift] != nil
              parsed_date = Chronic.parse(sf_s[:guest_chef_shift])
            elsif sf_s[:dig_shift] != nil
              parsed_date = Chronic.parse(sf_s[:dig_shift])
            elsif sf_s[:date] != nil
              parsed_date = Chronic.parse(sf_s[:date])
            elsif sf_s[:morning_shift] != nil
              parsed_date = Chronic.parse(sf_s[:morning_shift])
            elsif sf_s[:afternoon_shift] != nil
              parsed_date = Chronic.parse(sf_s[:afternoon_shift])
            end
          end
          if parsed_date
            date = parsed_date.to_date
            updated_shift.update!(date: date)
          end
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
          # add date depending on shift type, in this priority...
          if sf_s[:shift_type]
            if sf_s[:shift_type] == "Guest Chef" && sf_s[:guest_chef_shift] != nil
              parsed_date = Chronic.parse(sf_s[:guest_chef_shift])
            elsif sf_s[:shift_type] == "DIG" && sf_s[:dig_shift] != nil
              parsed_date = Chronic.parse(sf_s[:dig_shift])
            elsif sf_s[:shift_type] == "Admin/Office" && sf_s[:date] != nil
              parsed_date = Chronic.parse(sf_s[:date])
            elsif sf_s[:shift_type] == "Garden Morning" && sf_s[:morning_shift] != nil
              parsed_date = Chronic.parse(sf_s[:morning_shift])
            elsif sf_s[:shift_type] == "Garden Afternoon" && sf_s[:afternoon_shift] != nil
              parsed_date = Chronic.parse(sf_s[:afternoon_shift])
            end
          else
            if sf_s[:guest_chef_shift] != nil
              parsed_date = Chronic.parse(sf_s[:guest_chef_shift])
            elsif sf_s[:dig_shift] != nil
              parsed_date = Chronic.parse(sf_s[:dig_shift])
            elsif sf_s[:date] != nil
              parsed_date = Chronic.parse(sf_s[:date])
            elsif sf_s[:morning_shift] != nil
              parsed_date = Chronic.parse(sf_s[:morning_shift])
            elsif sf_s[:afternoon_shift] != nil
              parsed_date = Chronic.parse(sf_s[:afternoon_shift])
            end
          end
          if parsed_date
            date = parsed_date.to_date
            new_shift.update!(date: date)
          else
            new_shift.update!(date: "no date")
          end
          puts "Created Shift #{sf_s[:sf_volunteer_shift_id]}"
        end
        # add or update emergency info and notes for Shift's Volunteer
        volunteer = Volunteer.find_by(sf_contact_id: sf_s[:sf_contact_id])
        if sf_s[:emergency_contact_name] != nil
          volunteer.update!(emergency_contact_name: sf_s[:emergency_contact_name])
          puts "Updated Emergency Contact Name for Volunteer #{sf_s[:volunteer]} / #{sf_s[:sf_contact_id]}"
        end
        if sf_s[:emergency_contact_phone] != nil
          volunteer.update!(emergency_contact_phone: sf_s[:emergency_contact_phone])
          puts "Updated Emergency Contact Phone for Volunteer #{sf_s[:volunteer]} / #{sf_s[:sf_contact_id]}"
        end
        if sf_s[:notes] != nil
          volunteer.update!(notes: sf_s[:notes])
          puts "Updated Notes for Volunteer #{sf_s[:volunteer]} / #{sf_s[:sf_contact_id]}"
        end
      end

      # timestamp Syncer with current time
      Syncer.find_by(id: 1).update!(last_sync: DateTime.now.utc.iso8601, state: "complete")
    end

  end

  def update_no_shows(client)
    ActiveRecord::Base.connection_pool.with_connection do

      sign_ups = Shift.where(status: "Sign Up")
      sign_ups.each do |su|
        return unless Chronic.parse(su.date) != nil
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
end
