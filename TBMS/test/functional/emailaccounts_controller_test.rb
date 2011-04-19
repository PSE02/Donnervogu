# Author:: Jonas Ruef
require 'test_helper'

class EmailaccountsControllerTest < ActionController::TestCase
  setup do
    @emailaccount = emailaccounts(:hans)
    login_as_admin
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create emailaccount" do
    assert_difference('Emailaccount.count') do
      post :create, :emailaccount => { :name => "Fredi", :email => "fredi.fredi@fredi.com"}
    end
    assert_equal "Fredi", assigns(:profile).name
    assert_equal "fredi.fredi@fredi.com", assigns(:profile).email
    assert_redirected_to emailaccount_path(assigns(:profile))
  end
   
  test "should show emailaccount" do
    post :create, :emailaccount => { :name => "Fredi1", :email => "fredi.fredi@fredi.com"}    
    get :show, :id => assigns(:profile).id
    assert_response :success
  end

#  test "should update emailaccount" do
#    put :update, :id => @emailaccount.to_param, :emailaccount => @emailaccount.attributes
#    assert_redirected_to emailaccount_path(assigns(:emailaccount))
#  end
  
  test "should set params" do
  	#Use max account in fixtures because he has preferences defined
  	@emailaccount1 = emailaccounts(:max)
  	put :set_params, :id => @emailaccount1.to_param, :emailaccount => @emailaccount1.attributes
  	assert_redirected_to emailaccount_path(assigns(:profile))
  end

  test "should destroy emailaccount" do
    assert_difference('Emailaccount.count', -1) do
      delete :destroy, :id => @emailaccount.to_param
    end
    assert_redirected_to emailaccounts_path
  end
end
