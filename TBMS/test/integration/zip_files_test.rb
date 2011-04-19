require 'test_helper'
require 'stringio'
require 'zip/zip'

# This test checks that the sending of the configuration zip works
# for the standard protocol:
#     /profile/:email:
#         Returns a zip and in the X-TBMS-Profile-ID Header a new ID
#     /profile/:id:
#         Gives a zip only
#     /profile/:id:/ok
#         Signifies that the transaction was successful and updates the
#         status for that id.
#
# Author:: Aaron Karper <akarper@students.unibe.ch>
class ZipFilesTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  setup do
    @profile = emailaccounts :hans
    @hans_id = get_hans
  end

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
    is_valid_zip( get_zip_file)
    assert_match /\d+/, @response["X-TBMS-Profile-ID"]
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
    hans_sub = Subaccount.find(@hans_id.to_i)
    assert_in_delta(Time.now, hans_sub.last_get, 0.5)
  end

end
