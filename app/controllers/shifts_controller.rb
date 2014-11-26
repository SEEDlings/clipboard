class ShiftsController < ApplicationController
  before_action :client

    def confirm
      result = @client.update!('SEEDS_Volunteer_Shifts__c', Id: params[:shift_id], Shift_Status__c: "Confirmed")
      redirect_to shifts_index_path
    end
end
