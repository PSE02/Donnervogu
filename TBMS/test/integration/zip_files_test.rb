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
  def getZipFile string
    pseudoFile = Tempfile.new "received.zip" 
    pseudoFile.write string
    pseudofile.rewind
    Zip::ZipCentralDirectory.read_from_stream(pseudoFile)
  end
  
  def getHansLines
    @response.body\
        .to_s\
        .lines\
        .collect {|e| e.strip}
  end

  def generateHans
    post :create,
  end
  
  test "get address of hanses zip file" do
	  # https!
    get "/profile/hans@example.com"
    assert_response :success
    assert_match /user.js/, @response.body.to_s
  end
  
  test "get userjs of hanses profile" do
    get "/profile/txt/hans@example.com" # nonstandard action to circumvent the zip
    assert_response :success
    lines = getHansLines
    assert lines.any? {|line| /"mail.default_html_action",\s*2/.match line}
  end
  
  test "change userjs of hanses profile" do
    url = "/emailaccounts/#{@profile.email}/update/setParams"
    raise url
    post url, :setup => @profile.attributes
    assert_response :redirect
    follow_redirect!
    assert_response :success
    
    get "/profile/txt/hans@example.com" # nonstandard action to circumvent the zip
    assert_response :success
    lines = getHansLines
    assert lines.any? {|line| /"mail.default_html_action",\s*1/.match line}
  end
end
