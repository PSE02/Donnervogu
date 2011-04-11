include EmailaccountHelper
class Emailaccount < ActiveRecord::Base
  
	validates_presence_of :email
	validates_presence_of :name
  validates_format_of :email,
      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_format_of :name, :with => /^\w+$/i,
    :message => "can only contain letters and numbers."
  validates_uniqueness_of :email

	serialize :preferences
	belongs_to :group
	
  def initialize panda={}
	  super panda
    self.preferences = Hash.new
    self.loadInitPreferences
    self.last_get = Time.now
	end

  def self.oldestGet
	  self.minimum("last_get")
  end
	
	def setParams params
	  raise "No Params" if params.nil?
	  params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if validKey?(key)
	  end 
    self.save
    FileCreator::createNewZip(self)
    assureCreatedZip
  end
  
	def validKey? key
	    (not key.nil?) and (FileCreator::validKey?(key.to_sym))
	end
	
	def assureCreatedZip
	    FileCreator::createNewZip(self)
	    raise "No file created" unless File.exists? zipPath
	end

	def assureZipPath
		assureCreatedZip
		zipPath
	end
	
	def zipPath
		FileCreator::completeZipPath self
	end
	
	#DR we have to load group or template stuff here from a file or what ever
	def loadInitPreferences
	  self.preferences[:signature] = "This is just a template signature"
    self.preferences[:html] = "true"
	end
	
	def downloaded
		self.last_get = Time.now
	end

	# the preferences merged with the group's
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

  def update
    assureCreatedZip
  end
end
