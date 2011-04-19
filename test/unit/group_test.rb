require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  setup do
    @ft = groups :fantasticthree
    @ff = groups :fantasticfour
    @trampo = groups :trampolin
    @trampos = groups :trampolinsued
    @ft.group = @ff
    @trampos.group = @trampo
  end
  test "should merge non-conflicting" do
	  assert_equal(
		  {:html_mail => false, :quoting_style => :below},
		  @ft.final_preferences)
  end

  test "should merge conflicting" do
	  assert_equal(
		  {:html_mail => true, :quoting_style => :below},
		  @trampos.final_preferences)
  end
end
