include EmailaccountHelper
include TemplateHelper
class Emailaccount < ActiveRecord::Base

	validates_presence_of :email
	validates_presence_of :name
  validates_format_of :email,
      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_uniqueness_of :email

	serialize :preferences
  serialize :informations
	belongs_to :group
  has_many :subaccounts
  has_one :standard_subaccount,
      :class_name => "Subaccount"
	
  def initialize panda={} # panda = param
	  super panda
    self.preferences = Hash.new
    self.informations = Hash.new
    self.load_init_preferences
    self.standard_subaccount = Subaccount.new
  end

  def generate_subaccount
    sub = Subaccount.new
    sub.emailaccount = self
    raise "Couldn't save new Subaccount" unless sub.save
    sub.id
  end

  def set_group param
    return nil if param.nil?
    group = Group.find(param)
    if (group != self.group and group != nil)
      self.group = group
      group.emailaccounts << self
      raise "save error" unless self.save and group.save
    end
  end

  # Checks what the oldest configuration in the wild is of this account.
  # Author:: Aaron Karper <akarper@student.unibe.ch>
  def oldest_subaccount_config
    Subaccount.oldest_subaccount_config self.id
  end

	def set_params params
	  raise "No Params" if params.nil?
    params.each do |key, value|
	    raise "key nil" if key.nil?
	    raise "value nil" if value.nil?
	     self.preferences[key.to_sym] = value if valid_key?(key)
	  end 
    raise "save failed: #{errors}" unless self.save
    assure_created_zip
  end
  
	def valid_key? key
	    (not key.nil?) and (FileCreator::valid_key?(key.to_sym))
	end
	
	def assure_created_zip
	    FileCreator::createNewZip(self)
	    raise "No file created" unless File.exists? zip_path
	end

	def assure_zip_path
		assure_created_zip
		zip_path
	end
	
	def zip_path
		FileCreator::completeZipPath self
	end
	
	#DR we have to load group or template stuff here from a file or what ever
	def load_init_preferences
    self.group = Group.null_group
    self.preferences = self.group.final_preferences unless group.nil?
    self.informations[:email] = email
    self.informations[:name] = name
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

  # Part of the Composite Pattern that can update the whole dependency tree if necessary.
  def propagate_update
    self.preferences = self.group.preferences
    raise "Couldn't save" unless self.save
    assure_created_zip
  end

  def outdated?
    self.subaccounts.any? {|sub| sub.outdated?}
  end

  def signature
    template = preferences[:signature] or ""
    dict = TemplateHelper::make_dict self.informations
    TemplateHelper::instanciate_template template, dict
  end
end

