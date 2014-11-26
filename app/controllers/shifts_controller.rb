class ShiftsController < ApplicationController
  before_action :client

  def new
  end

  def confirm
    @client.update!('SEEDS_Volunteer_Shifts__c', Id: "a0bq00000000A39AAE", Shift_Status__c: "Confirmed")
  end

  def index
    @shifts = Shift.all
  end

  # def shifts_day
    # @shifts = []
    # @shift = testshift
    # @shift.date = "November 26"
    # @month = Date.today.strftime("%B")
    # @day = Date.today.day
    # @today = "#{@month}" + " #{@day}"
    # if @shift.date = @today
    #   render
    # else
    #
    # end
  # end

    #want to display the volunteer names associated with all today's shifts
end
