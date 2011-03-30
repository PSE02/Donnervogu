# Author:: Jonas Ruef
require 'test_helper'
class UserTest < ActiveSupport::TestCase

  test "the truth" do
    assert true
  end
    
  fixtures :users
  # Replace this with your real tests.
  test "admin exists" do
	  assert User.count != 0
  end
end
