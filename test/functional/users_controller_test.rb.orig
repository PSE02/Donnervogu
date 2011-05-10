# Author:: Jonas Ruef
# Needs admin account in the user fixtures, so don't delete.
require 'test_helper'

<<<<<<< HEAD
class UsersControllerTest < ActionController::TestCase

	test "should check if new page exists" do
    get :new
    assert_response :success
	end
	
	test "should prevent access if you are not a logged in user" do
		get :show
		assert_redirected_to '/user_sessions/new'
	end

	test "should grant you access if you are a logged in user" do
		login_as_admin
		get :show
		assert_response :success
	end

	test "should create user" do
		assert_difference "User.count" do
			post :create, :user => { :login => "superpippo", :password => "noccioline", :password_confirmation => "noccioline"}
			assert_redirected_to root_path
		end
		assert_equal "superpippo", assigns(:user).login
	end
end
=======
>>>>>>> 6819c20b6e03f3eeb9633855db9ec93405c5c6a4
