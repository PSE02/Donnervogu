require 'test_helper'

class SubaccountTest < ActiveSupport::TestCase
   setup do
     @account = Emailaccount.new
     @account.name = "test2"
     @account.email = "test2@example.ch"
     @account.save
     @subaccount = ProfileId.new
     @subaccount.emailaccount = @account
     @subaccount.save
  end
  test "test download" do
    lastget = @subaccount.last_get
    @subaccount.downloaded
    assert lastget < @subaccount.last_get
  end
end
