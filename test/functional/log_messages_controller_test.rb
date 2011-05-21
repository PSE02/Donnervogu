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
    @hanspid.save
    @hans = Emailaccount.find_by_email(hans.email)
  end

  test "fixture is good" do
    assert_equal "hans wurst", @hans.name
    assert @hans.profile_ids.include?(@hanspid), "#{@hans.profile_ids} didn't include #{@hanspid}, complete list is:\n"+ProfileId.all.collect(&:inspect).join("\n")
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
    assert_routing '/status/1', {:controller => "log_messages", :action => "handle_url", :id => "1"}
  end

  test "should handle error report" do
    assert_difference 'LogMessage.count', 1 do
      request.env['X-TBMS-Status'] = 'bla'
      get :handle_url, :id => @hanspid
      assert_response :ok
    end
  end

  # No Log should be created.
  test "should handle ok response" do
    request.env['X-TBMS-Status'] = ""
    get :handle_url, :id => @hanspid.to_param
    assert_response :ok
  end

  test "should log non ok response" do
    assert_difference "LogMessage.count", 1 do
      request.env.update({
                             'X-TBMS-Status' => 'OMG STUFF BROKE'
                         })
      get :handle_url, :id => @hanspid
      assert_response :ok
    end
  end
end
