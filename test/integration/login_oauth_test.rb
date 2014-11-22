require 'test_helper'

class LoginOauthTest < ActionDispatch::IntegrationTest
  should "login with salesforce and return to home" do
    background do
      visit root_path
      click_link 'Log in via Salesforce'

      OmniAuth.config.mock_auth[:salesforce] = {
          provider: 'salesforce',
          uid: user.salesforce_accoun.uid,
          credentials: {
              :oauth_token   => salesforce_auth.oauth_token,
              :refresh_token => salesforce_auth.refresh_token,
              :instance_url  => 'https://cs21.salesforce.com',
              :client_id     => ENV['SALESFORCE_KEY'],
              :client_secret => ENV['SALESFORCE_SECRET']
          }
      }
      end

    context 'click Log in via Salesforce' do
      click_link 'Log in via Salesforce'

      assert page.has_content('Woo')
    end

  end
  end
end
