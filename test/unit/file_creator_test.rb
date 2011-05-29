require 'test_helper'

# Tests for the fileCreator module
# Needs 3 emailaccounts in the fixtures called "hans", "juerg" and "max" - please don't delete them!
#
# Author::    Dominique Rahm
# License::   Distributes under the same terms as Ruby

class FileCreatorTest < ActiveSupport::TestCase
  setup do
    @hans = emailaccounts(:hans)
    @juerg = emailaccounts(:juerg)
    @max = emailaccounts(:max)
  end
  
  test "html text" do
    testString = FileCreator::html(@hans)
    assert_match(/mail.default_html_action.*2/, testString)
    assert_match(/mail.identity.id1.compose_html.*true/, testString)
  end
  
  test "quote text" do
    testString = FileCreator::quote(@hans)
    assert_match(/mail.identity.id1.reply_on_top.*(1|true)/, testString)
  end
  
  test "signature_style text disable" do
    testString = FileCreator::signature_style(@hans)
    assert_match("", testString)
  end
  
  test "signature_style text enable" do
    testString = FileCreator::signature_style(@hans)
    assert_match(/mail.identity.id1.sig_bottom.*false/, testString)
  end
  
  test "signature text" do
      testString = FileCreator::signature(@hans)
      assert_match(/mail.identity.id1.htmlSigFormat.*true/, testString)
      assert_match(/mail.identity.id1.htmlSigText.*"This is just a simple signature"/, testString)
  end
    
  test "enable offline mode" do
      testString = FileCreator::offline_mode(@hans)
      assert_match("user_pref(\"mail.server.server1.offline_download\", true);", testString)
  end

  test "set send_offline_mode" do
      testString = FileCreator::send_offline_mode @hans
      assert_match(/offline.send.unsent_messages.*1/, testString)
      testString = FileCreator::send_offline_mode @juerg
      assert_match(/offline.send.unsent_messages.*2/, testString)
      testString = FileCreator::send_offline_mode @max
      assert_equal("", testString)
  end
  
  test "enable save_offline_mode" do
      testString = FileCreator::save_offline_mode @juerg
      assert_match(/offline.download.download_messages.*1/, testString)
  end  
  
  test "disable save_offline_mode" do
      testString = FileCreator::save_offline_mode @max
      assert_match("", testString)
  end  
  
  test "complete file path" do
      filePath = FileCreator::completeZipPath @hans
      id = @hans.id
      assert_match("profiles/#{id}_profile.zip", filePath)
  end
  
  test "is not a validKey" do
    assert !(FileCreator::valid_key? :test)
  end
  
  test "should raise Emailaccount nil" do
    assert_raise (RuntimeError){ FileCreator::createNewZip nil } 
  end

  test "should raise Preferences nil" do
    return nil
    assert_raise (RuntimeError){ FileCreator::createNewZip @hans } 
  end
  
  test "create Zip" do
    zip_file_content = ""
    FileCreator::createNewZip @max
    assert FileTest.exist?("public/profiles/#{@max.id}_profile.zip")
    Zip::ZipFile.open( "public/profiles/#{@max.id}_profile.zip" )do
      |zipfile| 
      assert (zipfile.get_entry("user.js"))
      zip_file_content = zipfile.read("user.js") 
    end
    assert_match("user_pref(\"mail.identity.id1.htmlSigText\", \"Max Muster's signature\");", zip_file_content)
  end

  test "complete config file" do
      assert !(@hans.preferences.empty?)
      testString = FileCreator::getConfig @hans
      
      #HTML 
      assert_match("pref(\"mail.default_html_action\", 2);", testString)
 		  assert_match("user_pref(\"mail.identity.id1.compose_html\", true);", testString)
 		  
 		  #Quote
 		  assert_match("user_pref(\"mail.identity.id1.reply_on_top\", true);", testString)
 		  
 		  #Signature_style
     	assert_match("user_pref(\"mail.identity.id1.sig_bottom\", false);", testString)
    
      #Signature
      assert_match("user_pref(\"mail.identity.id1.htmlSigText\", \"This is just a simple signature\");", testString)
   end
   
end
