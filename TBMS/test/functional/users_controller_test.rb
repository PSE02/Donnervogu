# Author:: Jonas Ruef
require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  test "test the tests" do
    assert true
  end
  
  test "should prevent access if you are not a logged in user" do
  	get :show
    assert_redirected_to '/user_sessions/new'
  end
  
  test "should grant you access if you are a logged in user" do
    UserSession.create(users(:admin))
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