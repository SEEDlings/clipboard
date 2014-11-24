require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  context "a shift" do
    subject { shifts(:one) }

    should belong_to(:activity)
    should belong_to(:volunteer)

    should validate_presence_of(:date)
    should validate_presence_of(:hours)
    should validate_presence_of(:status)
  end

  context "when a shift is created by loading from Salesforce" do
    # it should validate sf_id, sf_volunteer_shift_id, sf_shift_detail_id
  end

  context "when a shift is created by clipboard" do
    # it should create the proper Salesforce objects
  end
end
