require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase
  context "a volunteer" do
    subject { volunteers(:one) }

    should have_many(:shifts)

    should validate_presence_of(:name_first)
    should validate_presence_of(:name_last)
    should validate_presence_of(:email)
  end
end
