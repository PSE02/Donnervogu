require 'test_helper'

# Tests for the CSVImport
#
# Do not delete test/test.csv
# I did us bottom-up testing, therefore I tested every single method first 
# and then tested the methods together
# Therefore:      
# import -> init -> initGroup 
#                -> initAccount
#  
# Author::    Dominique Rahm
# License::   Distributes under the same terms as Ruby

class CSVImportTest < ActiveSupport::TestCase
  setup do
    @hans = emailaccounts(:hans)
    @juerg = emailaccounts(:juerg)
    @max = emailaccounts(:max)
    @testGroup
  end
  
  test "initGroup" do
    count = Group.all.count
    @testGroup = CSVImport::initGroup("this.is.a.test.domain.ch")
    assert_false(Group.find_by_name("this.is.a.test.domain.ch").nil?)
    assert(count < Group.all.count)
    assert(Group.all.count == count + 1)
    assert_match("this.is.a.test.domain.ch",@testGroup.name)
  end
  
  test "initGroup again" do
    CSVImport::initGroup("this.is.a.test.domain.ch")
    count = Group.all.count
    CSVImport::initGroup("this.is.a.test.domain.ch")
    assert(Group.all.count == count)
  end
  
  test "initAccount" do
    @testGroup = CSVImport::initGroup("this.is.a.test.domain.ch")
    CSVImport::initAccount("hans.example@test.email.ch", @testGroup)
    assert_false(Emailaccount.find_by_email("hans.example@test.email.ch").nil?)
    account = Emailaccount.find_by_email("hans.example@test.email.ch")
    assert_match("hans.example", account.name)
    assert_match("this.is.a.test.domain", account.group.name)
  end
  
  test "init" do
    assert(Emailaccount.find_by_email("juerg.test@another.email.domain").nil?)
    assert(Group.find_by_name("another.email.domain").nil?)
    old_group_count = Group.all.count
    old_emailaccount_count = Emailaccount.all.count
    CSVImport::init("juerg.test@another.email.domain", "another.email.domain")
    assert(old_group_count < Group.all.count)
    assert(old_emailaccount_count < Emailaccount.all.count)
    assert_false(Emailaccount.find_by_email("juerg.test@another.email.domain").nil?)
    assert_false(Group.find_by_name("another.email.domain").nil?)
  end
  
  test "import" do
    test_file_path = File.join(Rails.root,"resources",
             "test.csv",)
    CSVImport::import(File.read(test_file_path))
    assert_false(Emailaccount.find_by_email("hans@example.ch").nil?)
    assert_false(Emailaccount.find_by_email("max.test@another.email.ch").nil?)
    assert_match("another.email",Emailaccount.find_by_email("max.test@another.email.ch").group.name) 
    assert_false(Group.find_by_name("another.email.ch").nil?)
    assert_false(Group.find_by_name("example.ch").nil?)
  end
    
end
