require 'cover_me'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'


class ActiveSupport::TestCase
   # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Helper method for tests, use this method when you have 
# to test a controller's method which is only accessible for logged in user.
# Logs you in as user: admin
def login_as_admin
	UserSession.create(users(:admin))
end

# Needed for user_controller and user_session_controller tests
class ActionController::TestCase
  setup :activate_authlogic
end