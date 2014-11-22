require 'test_helper'
require 'rspec/rails'
require File.expand_path('spec/spec_helper')

class LoginOauthTest < ActionDispatch::IntegrationTest
  should  "direct to salesforce login" do
    login
    title = "Where do I go?"
    text = "Not sure"
    tag = "tag1,"

    visit root_path

    click_on "Ask"

    assert page.has_content?("tag1")
  end
end
