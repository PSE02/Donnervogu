# Author:: Jonas Ruef
class User < ActiveRecord::Base

  # Do not delete the Authlogic::Session module relies on.
	acts_as_authentic
	
	# Authenticate user via username
	def self.find_by_username(login)
		find_by_login(login)
	end
end