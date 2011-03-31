require 'test_helper'

# Tests for the emailaccount model
# Needs 1 emailaccount in the fixtures called "hans" - please don't delete them!
#
# Author::    Sascha Schwaerzler, Dominique Rahm
# License::   Distributes under the same terms as Ruby

class EmailaccountTest < ActiveSupport::TestCase
  
  fixtures :emailaccounts
  
  setup do
    @hans = emailaccounts(:hans)
    @account = Emailaccount.new
    @account.name = "test2"
    @account.email = "test2@example.ch"
    @account.save
  end
    
  test "hans exists" do
	  assert User.all != []
  end
  
  test "create new emailaccount" do
    @newaccount = Emailaccount.new
    @newaccount.name = "test"
    @newaccount.email = "test@example.ch"
    @newaccount.save
    
    assert @newaccount.preferences == {:html => "true", :signature => "This is just a template signature"}
    assert @newaccount.last_get < Time.now
  end

  test "setParams with nil" do
    assert_raise (RuntimeError){  @hans.setParams nil } 
  end
  
  test "setParams for real" do  
    hash = {:html => "false", :quote => "0"}
    @account.setParams hash
    assert (@account.preferences == {:html => "false", :quote => "0", :signature => "This is just a template signature"})
   end
  
  test "test download" do
    lastget = @account.last_get
    @account.downloaded
    assert lastget < @account.last_get
  end
  
  test "assure zip path fail" do
    assert_raise(RuntimeError) { @hans.assureZipPath}
  end  
  
  test "assure zip path" do
    path = @account.assureZipPath
    assert_match("profiles/#{@account.id}_profile.zip", path)
  end 
  
end
