# Author:: Jonas Ruef
class User < ActiveRecord::Base

  # Automatic logout after 15 Minutes Account inactivity
	acts_as_authentic do |c|
    c.logged_in_timeout(1.minutes)
  end

	# Authenticate user via username
	def self.find_by_username(login)
		find_by_login(login)
	end
end