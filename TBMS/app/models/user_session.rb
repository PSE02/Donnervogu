#Author:: Jonas Ruef
#Model for user sessions, simply does make shure you can use a username instead of email to log in.
class UserSession < Authlogic::Session::Base
	find_by_login_method :find_by_username
end
