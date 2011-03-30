# Author:: Jonas Ruef
require 'test_helper'
require 'haml'
require 'haml/template/plugin'

class UsersControllerTest < ActionController::TestCase

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
   assert_difference('users.count') do
      post :create, :users => { :login => "admin", :password => "admin", :password_confirmation => "admin" }
    end
    
    assert_redirected_to account_path
  end

  test "should show user" do
   UserSession.create(users(:admin))
    get :show
    assert_response :success
  end
end