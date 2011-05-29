# Emailaccounts can belong to groups and merge their preferences
# with the groups. This merge is done once on the creation
# of the account and then on request.
# Author:: Aaron Karper <akarper@students.unibe.ch>
include GroupsHelper
class Group < ActiveRecord::Base
  # This is somewhat suboptimal, but inheritance in databases and
  # rails is really hard work.

	validates_presence_of :name
  validates_uniqueness_of :name
	has_many :emailaccounts
	belongs_to :group
	has_many :groups
	serialize :preferences

	def initialize params={}
		super params
		self.preferences = Hash.new
  end

  # Every User belongs to a group, which might be the default_group
  def self.default_group
    @default_group ||=
        Group.find_by_name("No Group") ||
            Group.create(:name => "No Group",
                         :preferences => {
                             :html => "true",
                             :signature => "This is just a template signature"})
    @default_group
  end

	# a list of all members (groups and emailaccounts)
	def members
		self.groups + self.emailaccounts
	end

	def to_s
		self.name
	end

	# the preferences in the hierarchy down to this point.
	def final_preferences
		if not self.group.nil?
			merge_down
		else
			self.preferences
		end
	end

	# Overwrite the supergroups preferences if necessary
	def merge_down
		self.group.final_preferences.merge self.preferences
	end

  # Changes are propagated down the hierarchy.
  def propagate_update
    self.preferences = self.group.final_preferences unless self.group.nil?
    self.members.each {|member| member.propagate_update}
  end

  # Change the preferences according to the FileCreator.
  def set_params params
	  raise "No Params" if params.nil?
	  params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if FileCreator::valid_key?(key.to_sym)
	  end
    raise "Couldn't save" unless self.save
  end

end
