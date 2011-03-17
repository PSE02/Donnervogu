require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  # Replace this with your real tests.
  test "hans exists" do
	  assert User.all != []
  end
end
