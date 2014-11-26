require 'test_helper'
require 'rspec/rails'
require File.expand_path('spec/spec_helper')

class LoginOauthTest < ActionDispatch::IntegrationTest
  feature "login directs to salesforce" do
    scenario "logging in with salesforce" do
      visit root_url
      click_link "Log in via Salesforce"
      expect(page).to have_text("Salesforce")
    end
  end
end
