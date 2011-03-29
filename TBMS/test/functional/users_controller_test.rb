# Author:: Jonas Ruef
require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
   assert_difference('User.count') do
      post :create, :user => { :login => "testUser", :password => "testUserPw", :password_confirmation => "testUserPw" }
    end
    
    assert_redirected_to account_path
  end

  test "should show user" do
   UserSession.create(users(:testUser))
    get :show
    assert_response :success
  end
end