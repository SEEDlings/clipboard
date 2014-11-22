require 'test_helper'

class UserTest < ActiveSupport::TestCase
    context "User class" do
      should "be able to create a new user via auth_hash" do
        auth_hash = { "provider" => "test",
                      "uid" => "10",
                      "info" => {
                          "name" => "Test User",
                          "email" => "user@example.org"
                      },
                      "credentials" => { "token" => "TESTTOKEN" }
        }
        user = User.find_or_create_by_auth_hash(auth_hash)
        assert_not_nil user
        assert_equal "Test User", user.name
        assert user.persisted?

        assert_includes user.authorizations,
                      Authorization.find_by(provider: "test", uid: "10")
      end
    end

    should "be able to find an existing user via auth_hash" do
      auth = authorizations(:one)
      auth.user = users(:one)
      auth_hash = { "provider" => auth.provider,
                    "uid" => auth.uid,
                    "info" => {"name" => auth.user.name,
                               "email" => auth.user.email},
                    "credentials" => { "token" => auth.oauth_token } }

      user = User.find_or_create_by_auth_hash(auth_hash)
      assert_equal auth.user, user
    end

    context "a user" do
      should validate_presence_of(:name)
      # should validate_presence_of(:email)
      # should validate_uniqueness_of(:email)
    end
end

