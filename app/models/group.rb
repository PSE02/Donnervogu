class Group < ActiveRecord::Base
	validate :name, :presence => true
	has_many :user
	serialize :preferences
end
