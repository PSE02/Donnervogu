require 'test_helper'

class EmailaccountsControllerTest < ActionController::TestCase
  setup do
    @emailaccount = emailaccounts(:hans)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emailaccounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create emailaccount" do
    assert_difference('Emailaccount.count') do
      post :create, :emailaccount => @emailaccount.attributes
    end

    assert_redirected_to emailaccount_path(assigns(:emailaccount))
  end

  test "should show emailaccount" do
    get :show, :id => @emailaccount.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @emailaccount.to_param
    assert_response :success
  end

  test "should update emailaccount" do
    put :update, :id => @emailaccount.to_param, :emailaccount => @emailaccount.attributes
    assert_redirected_to emailaccount_path(assigns(:emailaccount))
  end

  test "should destroy emailaccount" do
    assert_difference('Emailaccount.count', -1) do
      delete :destroy, :id => @emailaccount.to_param
    end

    assert_redirected_to emailaccounts_path
  end
end
