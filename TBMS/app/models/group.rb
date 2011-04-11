# Emailaccounts can belong to groups and merge their preferences
# with the group's.
include GroupsHelper
class Group < ActiveRecord::Base
	validates_presence_of :name
	has_many :emailaccounts
	# This is somewhat suboptimal, but inheritance in databases and
	# rails is really hard work.
	belongs_to :group
	has_many :groups
	serialize :preferences

	def initialize params={}
		super params
		self.preferences = Hash.new
	end

	# a list of all members (groups and emailaccounts)
	def members
		self.groups + self.emailaccounts
	end

	def to_s
		self.name
	end

	# the preferences in the hierarchy this far.
	def final_preferences
		if not self.group.nil?
			down_merge
		else
			self.preferences
		end
	end

	# Overwrite the supergroups preferences if necessary
	def down_merge
		self.group.final_preferences.merge self.preferences
	end

	# Overwrite the subgroups preferences if necessary
	def up_merge
		self.preferences.merge self.group.final_preferences
  end

  def propagate_update
    self.members.each {|member| member.propagate_update}
  end

  def setParams params
	  raise "No Params" if params.nil?
	  params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if FileCreator::validKey?(key)
	  end
    self.save
    self.update
  end

end
