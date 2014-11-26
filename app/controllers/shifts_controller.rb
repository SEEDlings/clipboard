class ShiftsController < ApplicationController

  def findshifts
    @shifts = []
    @shift = testshift
    @shift.date = "November 26"
    @month = Date.today.strftime("%B")
    @day = Date.today.day
    @today = "#{@month}" + " #{@day}"

  end

    #want to display the volunteer names associated with all today's shifts
  end
end
