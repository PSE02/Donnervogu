require 'test_helper'

class EmailaccountTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  fixtures :emailaccounts
  # Replace this with your real tests.
  test "hans exists" do
	  assert User.all != []
  end
end
