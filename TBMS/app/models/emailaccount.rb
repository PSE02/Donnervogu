class EmailAccount < ActiveRecord::Base
	validate :email, :presence => true
	validate :name, :presence => true
	serialize :preferences
end

