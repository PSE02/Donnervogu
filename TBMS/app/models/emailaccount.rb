class Emailaccount < ActiveRecord::Base
	validates_presence_of :email
	validates_presence_of :name
	serialize :preferences
	
  @@fc = FileCreator.new
	
  def initialize panda={}
	  super panda
    self.preferences = Hash.new
    self.loadInitPreferences
	end
	
	def setParams params
	  raise "No Params" if params.nil?
	  params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if validKey?(key)
	  end 
    self.save
    @@fc.createNewZip(self)
  end
  
	def validKey? key
	  raise "No creator" if @@fc.nil?
    (not key.nil?) and (@@fc.validKey?(key.to_sym))
	end
	
	def zipPath
    "/profiles/#{self.id}_profile.zip"
	end
	
	#DR we have to load group or template stuff here from a file or what ever
	def loadInitPreferences
	  self.preferences[:signature] = "This is just a template signature"
	end
	
end
