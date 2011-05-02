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
    @hans_id = get_hans
  end

  #once this works, it will be awesome. However, zip/zip is buggy
  #and wont allow it. 
  def get_zip_file
    string = response.body
    pseudo_file = Tempfile.new "received.zip"
    string.force_encoding("UTF-8")
    pseudo_file.write string
    pseudo_file.rewind
    Zip::ZipCentralDirectory.read_from_stream(pseudo_file).to_a
  end
  
  def get_hans
    get "/profile/hans@example.com"
    assert_response :success
    @response["X-TBMS-Profile-ID"]
  end

  def is_valid_zip zip
    assert_not_empty zip
    assert zip.any? {|file| file.name == "user.js"}
  end

  test "get hanses id" do
    assert_match /\d+/, @hans_id
  end

  test "get hanses zip" do
    @hans_id
    is_valid_zip( get_zip_file)
  end

  test "get hanses zip by id" do
    id = @hans_id
    get "/profile/#{id}"
    is_valid_zip( get_zip_file)
  end

  test "check hanses zip" do
    zip = get_zip_file
    userjs = zip.detect {|e| e.name == "user.js"}
    lines =userjs.get_input_stream.readlines
    assert lines.any? {|line| /"mail.default_html_action",\s*2/.match line}
  end

  test "send ok" do
    get "profile/#{@hans_id}/ok"
    hans_sub = ProfileId.find(@hans_id.to_i)
    assert_in_delta(Time.now, hans_sub.last_get, 0.5)
  end

end
