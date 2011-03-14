require 'test_helper'

class SetupsControllerTest < ActionController::TestCase
  setup do
    @setup = setups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:setups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create setup" do
    assert_difference('Setup.count') do
      post :create, :setup => @setup.attributes
    end

    assert_redirected_to setup_path(assigns(:setup))
  end

  test "should show setup" do
    get :show, :id => @setup.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @setup.to_param
    assert_response :success
  end

  test "should update setup" do
    put :update, :id => @setup.to_param, :setup => @setup.attributes
    assert_redirected_to setup_path(assigns(:setup))
  end

  test "should destroy setup" do
    assert_difference('Setup.count', -1) do
      delete :destroy, :id => @setup.to_param
    end

    assert_redirected_to setups_path
  end
end
