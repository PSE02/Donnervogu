# Author:: Jonas Ruef
class UserSession < Authlogic::Session::Base
  #Reset persistence token, to make sure all sessions of user will be logged out.
  before_destroy :reset_persistence_token

  # Enforces you can use a username instead of email to log in
	find_by_login_method :find_by_username

  self.logout_on_timeout = true

  def reset_persistence_token
    record.reset_persistence_token
  end
end
