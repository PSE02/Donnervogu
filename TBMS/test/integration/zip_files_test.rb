require 'test_helper'
require 'stringio'
require 'zip/zip'

# This test can't work at this stage, because:
#     * There are no Profiles at the moment
#     * Therefore there are no fixtures for hans
#     * 
class ZipFilesTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  setup do
    @profile = emailaccounts :hans
  end
  
  #once this works, it will be awesome. However, zip/zip is buggy
  #and wont allow it. 
  def get_zip_file string
    pseudo_file = Tempfile.new "received.zip"
    string.force_encoding("UTF-8")
    pseudo_file.write string
    pseudo_file.rewind
    Zip::ZipCentralDirectory.read_from_stream(pseudo_file)
  end
  
  def get_hans_lines
    @response.body\
        .to_s\
        .lines\
        .collect {|e| e.strip}
  end

  def generate_hans
    post :create, @profile
  end

  def login
    https!
    get "/login"
    assert_response :success

    post_via_redirect "/login", :username => "admin", :password => "admin"
  end

  def get_hans
    get "/profile/hans@example.com"
    assert_response :success
    @response["X-TBMS-Profile-ID"]
  end

  test "get hanses id" do
    get_hans
    assert_match /\d+/, @response["X-TBMS-Profile-ID"]
  end

  test "get hanses zip" do
    get_hans
    zip = get_zip_file @response.body
    zip.
  end

  test "get userjs of hanses profile" do
    get "/profile/txt/hans@example.com" # nonstandard action to circumvent the zip
    assert_response :success
    lines = get_hans_lines
    assert lines.any? {|line| /"mail.default_html_action",\s*2/.match line}
  end

  test "change userjs of hanses profile" do
    url = "/emailaccounts/#{@profile.email}/update/set_params"
    post url, :setup => @profile.attributes
    assert_response :redirect
    follow_redirect!
    assert_response :success

    get "/profile/txt/hans@example.com" # nonstandard action to circumvent the zip
    assert_response :success
    lines = get_hans_lines
    assert lines.any? {|line| /"mail.default_html_action",\s*1/.match line}
  end
end
