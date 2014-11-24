require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  context "an activity" do
    subject { activities(:one) }

    should belong_to(:event)
    should have_many(:shifts)

    should validate_presence_of(:name)
    should validate_presence_of(:date)
  end
end
