# Author:: Jonas Ruef
class UserSession < Authlogic::Session::Base
	# Enforces you can use a username instead of email to log in
	find_by_login_method :find_by_username
end
