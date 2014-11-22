require 'test_helper'
require 'rspec/rails'
require File.expand_path('spec/spec_helper')

class LoginOauthTest < ActionDispatch::IntegrationTest
  describe "Lgin with salesforce" do
    cgit ontext "Clicking the login link" do
      it "Login button should log in" do
        visit root_path
        click_link 'Login with Salesforce'
        page.should have_text 'Woo'
      end
    end
  end
end
