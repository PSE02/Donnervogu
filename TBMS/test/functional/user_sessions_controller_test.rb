require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user session" do
    post :create, :session => { :login => "testUser", :password => "testUserPw" }
    assert user_session = UserSession.find
    assert_equal users(:testUser), user_session.user
    assert_redirected_to account_path
  end

   test "should destroy user session" do
    delete :destroy
    assert_nil UserSession.find
    assert_redirected_to new_user_session_path
  end
end