require 'test_helper'

class VolunteerTest < ActiveSupport::TestCase
  context "a volunteer" do
    subject { volunteers(:one) }

    should have_many(:shifts)

    should validate_presence_of(:name_first)
    should validate_presence_of(:name_last)
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
  end

  context "when creating a volunteer" do

    context "from Salesforce data" do

      context "when there is not an existing volunteer in our DB" do
        # create the volunteer
      end
      context "when there is an existing volunteer with the same info in our DB" do

        context "and the data is the same" do
          # do not create the volunteer, but continue creating the shift
        end
        context "and the data is different" do
          # update the info in our DB
        end
      end
    end

    context "from our form" do

      context "when there is not an existing Contact in Salesforce" do
        # create the SF Contact
      end
      context "when there is an existing Contact in Salesforce" do

        context "and the data is the same" do
          # do not create a contact, but continue creating the vol shift and shift detail
        end
        context "and the data is different" do
          # update the Salesforce Contact info
        end
      end
    end
  end
end
