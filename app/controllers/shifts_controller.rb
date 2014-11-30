class ShiftsController < ApplicationController
  before_action :client

  def confirm
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Confirmed")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Confirmed')
    end
    render partial: 'shifts/index'
  end

  def unconfirm
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Sign Up")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Sign Up')
    end
    render partial: 'shifts/index'
  end

  def cancellation
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Canceled")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Canceled')
    end
    render partial: 'shifts/index'
  end

  def no_show
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "No Show")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'No Show')
    end
    render 'index'
  end
end

