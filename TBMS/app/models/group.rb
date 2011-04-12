# Emailaccounts can belong to groups and merge their preferences
# with the group's. This merge is done once on the creation
# of the account and then on request.
# Author:: Aaron Karper <akarper@students.unibe.ch>
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

  # Every User belongs to a group, which might be the null_group
  def self.null_group
    if @null_group.nil?
      @null_group = Group.new
      @null_group.name = "No Group"
      @null_group.preferences={:html => "true", :signature => "This is just a template signature"}
      @null_group.save
    end
    @null_group
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

  # Changes might be propagated down the hierarchy.
  def propagate_update
    self.members.each {|member| member.propagate_update}
  end

  # Change the preferences according to the FileCreator.
  def set_params params
	  raise "No Params" if params.nil?
	  params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if FileCreator::valid_key?(key)
	  end
    self.save
    self.propagate_update
  end

end
