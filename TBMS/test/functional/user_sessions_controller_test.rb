# Author:: Jonas Ruef
# Needs admin account in the user fixtures, so don't delete.
require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

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
		login_as_admin
	    admin = users(:admin)
 	    assert_equal session["user_credentials"], admin.persistence_token
 	    delete :destroy, :id => admin.id
 	    assert_nil session["user_credentials"]
 	    assert_redirected_to root_url
	end
end