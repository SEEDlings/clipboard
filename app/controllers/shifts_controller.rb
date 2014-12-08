class ShiftsController < ApplicationController
  before_action :client

  def sync_and_list
    Syncer.find_by(id: 1).syncup(@client)
    list
    Syncer.find_by(id: 1).update_no_shows(@client)
  end

  def list
    render partial: "index"
  end

  def confirm
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Confirmed")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Confirmed')
    end
    flash[:notice] = "#{Shift.find_by(sf_volunteer_shift_id: shift).volunteer.name_first}'s shift confirmed in Salesforce"
    redirect_to root_path
  end

  def unconfirm
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Sign Up")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Sign Up')
    end
    flash[:notice] = "#{Shift.find_by(sf_volunteer_shift_id: shift).volunteer.name_first}'s shift was un-confirmed"
    redirect_to root_path
  end

  def cancellation
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "Canceled")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'Canceled')
    end
    redirect_to root_path
  end

  def no_show
    shift = params[:sf_volunteer_shift_id]
    if @client.update!('SEEDS_Volunteer_Shifts__c', Id: "#{shift}", Shift_Status__c: "No Show")
      Shift.find_by(sf_volunteer_shift_id: shift).update!(status: 'No Show')
    end
    redirect_to root_path
  end
end
