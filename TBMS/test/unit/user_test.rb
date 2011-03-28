require 'test_helper'
class UserTest < ActiveSupport::TestCase

  # Replace this with your real tests.
  test "the truth" do
    assert true
    
  fixtures :users
  # Replace this with your real tests.
  test "hans exists" do
	  assert User.all != []
  end
end
