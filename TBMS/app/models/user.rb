class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end
  def self.find_by_username_or_email(login)
   find_by_email(login) || find_by_login(login)
end
end