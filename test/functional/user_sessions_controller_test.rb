# Author:: Jonas Ruef
# Needs admin account in the user fixtures, so don't delete.
require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

	test "test the tests" do
		assert true
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should create user session" do
		post :create, :user_session => { :login => "admin", :password => "admin" }
		assert user_session = UserSession.find
		assert_equal users(:admin), user_session.user
		assert_redirected_to 'index#show'
	end

	test "should destroy user session" do
		delete :destroy
		assert_nil UserSession.find
		assert_redirected_to new_user_session_path
	end
end