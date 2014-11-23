require 'spec_helper'


def login_with_oauth(service = :salesforce)
  visit "/auth/#{service}"
end


feature 'testing oauth' do
  scenario 'should create a new session' do
    visit root_path
    click_on 'Log in via Salesforce'

    login_with_oauth
    fill_in 'User Name', :with => 'Rebecca'
    fill_in 'Password', :with => 'password'
    #do these correspond to oauth or the salesforce login? should the fields correspond to fixtures? should we be testing these?
    expect(page).to have_content("Woo")
  end
end
