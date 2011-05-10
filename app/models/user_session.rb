# Author:: Jonas Ruef
class UserSession < Authlogic::Session::Base
  #Reset persistence token when destroy a session, to make sure all sessions of that user will be logged out.
  before_destroy :reset_persistence_token

  # Login via username
	find_by_login_method :find_by_username

  self.logout_on_timeout = true

  def reset_persistence_token
    record.reset_persistence_token
  end
end
