require 'test_helper'

class LogMessagesControllerTest < ActionController::TestCase
  setup do
    @log_message = log_messages(:one)
    login_as_admin

    hans = Emailaccount.new
    hans.email = "hans.wurst@example.com"
    hans.name = "hans wurst"
    hans.save
    @hanspid = hans.generate_profile_id
    @hans = Emailaccount.find_by_email(hans.email)
  end

  test "fixture is good" do
    assert_equal "hans wurst", @hans.name
    assert_true @hans.profile_ids.collect(&:id).include? @hanspid
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:log_messages)
  end

  test "should show log_message" do
    get :show, :id => @log_message.to_param
    assert_response :success
  end

  test "should destroy log_message" do
    assert_difference('LogMessage.count', -1) do
      delete :destroy, :id => @log_message.to_param
    end

    assert_redirected_to log_messages_path
  end

  test "should handle log" do
    assert_routing '/status/1', {:controller => "log_messages", :action => "handle", :id => "1"}
  end

  test "should handle error report" do
    assert_difference 'LogMessage.count', 1 do
      request.env['X-TBMS-Status'] = 'false'
      request.env['X-TBMS-Status-Mesg'] = 'bla'
      get :handle, :id => @hanspid
      assert_response :ok
    end
  end

  # No Log should be created.
  test "should handle ok response" do
    request.env['X-TBMS-Status'] = "true"
    get :handle, :id => @hanspid.to_param
    assert_response :ok
  end

  test "should log non ok response" do
    assert_difference "LogMessage.count", 1 do
      request.env.update({
                             'X-TBMS-Status' => "false",
                             'X-TBMS-Status-Mesg' => 'OMG STUFF BROKE'
                         })
      get :handle, :id => @hanspid
      assert_response :ok
    end
  end
end
