require 'test_helper'

class UserTest < ActiveSupport::TestCase
<<<<<<< HEAD
  # Replace this with your real tests.
  test "the truth" do
    assert true
=======
  fixtures :users
  # Replace this with your real tests.
  test "hans exists" do
	  assert User.all != []
>>>>>>> 0b22175a448185e3e7e4e40eea63bf3abceb515c
  end
end
