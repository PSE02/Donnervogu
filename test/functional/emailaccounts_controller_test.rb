# Author:: Jonas Ruef
# Relies on emailaccounts fixtures, so don't delete them.
require 'test_helper'

class EmailaccountsControllerTest < ActionController::TestCase
  fixtures :emailaccounts, :profile_ids
  setup do
    @emailaccount = emailaccounts(:hans)
    @emailaccount.setup_members
    login_as_admin
  end

  test "fixture valid" do
    assert_not_nil(@emailaccount.standard_subaccount)
    assert_not_nil(@emailaccount.standard_subaccount.id)
    assert_equal(@emailaccount, @emailaccount.standard_subaccount.emailaccount)
    assert_not_nil(@emailaccount.id)
  end
  
#  test "should get index" do
#    get :index
#    assert_response :success
#  end
  
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

  test "cannot create too many ids"  do
    email = Emailaccount.first
    assert_difference("email.profile_ids.size", 10) do
      (1..20).collect {|e| email.generate_profile_id}
    end
  end


  test "should use if_modified_since header" do
    email = Emailaccount.first
    id = email.generate_profile_id
    email.updated_at = 4.days.ago
    email.save
    request.set_header('If-Modified-Since', Time.now.rfc2822)
    get :zip_of_id, :id => id
    assert_response 304
  end
end
