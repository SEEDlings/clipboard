class ShiftsController < ApplicationController
  before_action :client

    def confirm
      shift = params[:sf_volunteer_shift_id]
      if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Confirmed")
        Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Confirmed')
      end
        render shifts_index_path
    end
end
