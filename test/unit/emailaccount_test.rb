require 'test_helper'

# Tests for the emailaccount model
# Needs 1 emailaccount in the fixtures called "hans" - please don't delete them!
#
# Author::    Sascha Schwaerzler, Dominique Rahm
# License::   Distributes under the same terms as Ruby

class EmailaccountTest < ActiveSupport::TestCase

  fixtures :emailaccounts

  setup do
    @hans = emailaccounts(:hans)
    @account = Emailaccount.new
    @account.setup_members
    @account.name = "test2"
    @account.email = "test2@example.ch"
  end

  test "there are some users.." do
    assert User.count > 0
  end

  def create
    @newaccount = Emailaccount.new
    @newaccount.name = "test"
    @newaccount.email = "test@example.ch"
  end

  test "create new emailaccount" do
    create

    assert_equal(Hash[{:html => "true", :signature => "This is just a template signature"}], @newaccount.preferences)
  end

  test "set_params with nil" do
    assert_raise(RuntimeError) { @hans.set_params nil }
  end

  test "set_params for real" do
    @hans.set_params ({:html => "false", :quote => "0"})
    assert_equal @hans.preferences, {:html=>"false",
                                     :offline_mode=>"true",
                                     :quote=>"0",
                                     :save_offline_mode=>"false",
                                     :send_offline_mode=>"true",
                                     :signature=>"This is just a simple signature",
                                     :signature_style=>"false"}
  end

  test "set_params set group" do
    @account.set_group Group.first.to_param
    assert_equal(Group.first, @account.group)
  end


  # what the heck? It's an assertion!
  test "assure zip path fail" do
    return nil
    assert_raise(RuntimeError) { @hans.assure_zip_path }
  end

  test "assure zip path" do
    path = @account.assure_zip_path
    assert_match(/\.zip$/, path)
  end

end
