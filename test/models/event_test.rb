require 'test_helper'

class EventTest < ActiveSupport::TestCase
  context "an event" do
    subject { events(:one) }

    should have_many(:activities)

    should validate_presence_of(:name)
    should validate_presence_of(:date)
    should validate_presence_of(:recurrence)
  end
end
