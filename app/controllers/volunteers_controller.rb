class VolunteersController < ApplicationController
  before_action :client

  def new
    @volunteer = Volunteer.new
  end

  def testaction
    #needs to look at form to obtain params
    @firstname = testaction_params[:name_first]
    @lastname = testaction_params[:name_last]
    @email = testaction_params[:email]
    @existing_records = []
    @matching_names = []
    @existing = @client.query("select Id from contact where email = '#{@email}'")
    @existing.current_page.each do |o|
      @existing_records << o.Id
    end

    @existing_records.each do |o|
      @matching_names << client.find('Contact', "#{o}")
    end
    if @matching_names.empty?
      @client.create!('Contact', FirstName: testaction_params[:name_first], LastName: testaction_params[:name_last], Email: testaction_params[:email] )
        Volunteer.find_or_create_by!(email: testaction_params[:email]) do |volunteer|
            volunteer.name_first = testaction_params[:name_first]
            volunteer.name_last = testaction_params[:name_last]
          end
    else
      puts 'We already have someone in the database with that email'
    end
  end

  private

  def testaction_params
    params.require(:volunteer).permit(:name_first, :name_last, :email)
  end
end
