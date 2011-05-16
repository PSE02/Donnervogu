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
		  {:html=> false, :quote => :below},
		  @ft.final_preferences)
  end

  test "should merge conflicting" do
	  assert_equal(
		  {:html => true, :quote => :below},
		  @trampos.final_preferences)
  end
  
  test "should raise error if params nil" do
    assert_raise(RuntimeError) { @ft.set_params nil }
  end
  
  test "should set params" do
     @ft.set_params (Hash[:html => true, :quote => :above])
     assert_equal(Hash[:html => true, :quote => :above], @ft.preferences)
   end
end
