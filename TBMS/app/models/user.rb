class User < ActiveRecord::Base
  acts_as_authentic do |c|
  end
  def self.find_by_username(login)
   find_by_login(login)
end
end