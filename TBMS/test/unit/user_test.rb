require 'test_helper'
class UserTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
    
  fixtures :users
  # Replace this with your real tests.
  test "admin exists" do
	  assert User.count != 0
  end
end
