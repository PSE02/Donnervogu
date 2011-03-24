class User < ActiveRecord::Base

	validate :email, :presence => true
	validate :name, :presence => true
	serialize :preferences

  acts_as_authentic do |c|
  end

end

