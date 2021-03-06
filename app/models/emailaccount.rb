include EmailaccountHelper
include TemplateHelper
# Emailaccounts store their configuration (in the <code>preferences</code>
# map) and provide users with the corresponding zip files. It starts without
# a group, but it can be provided later, if need be. It has serveral
# profile ids, that represent the different clients with the same configuration.
#
# Author: 
class Emailaccount < ActiveRecord::Base

  validates_presence_of :email
  validates_presence_of :name
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  # We identify an account by its email on the first request.
  validates_uniqueness_of :email

  serialize :preferences
  serialize :informations
  belongs_to :group
  has_many :profile_ids,
           :autosave => true,
           :dependent => :destroy,
           :conditions => {:emailaccount_type => "listed"}
  has_one :standard_subaccount,
          :class_name => "ProfileId",
          :autosave => true,
          :dependent => :destroy,
           :conditions => {:emailaccount_type => "standard"}
  validate :not_too_many_ids

  after_initialize :setup_members

  def not_too_many_ids
    if too_many_ids
      errors.add_to_base ("Too many profile ids")
    end
  end

  def too_many_ids
     ProfileId.count(:conditions => {:emailaccount_id => self.id, :emailaccount_type => 'listed'}) >= max_id_count
  end

  def max_id_count
    10
  end

  def setup_members
    self.group ||= Group.default_group    # Idiomatic way to set if it has not been set yet.
    self.preferences ||= self.group.final_preferences
    self.informations ||= {:email => email, :name => name}
    self.create_standard_subaccount
  end

  # makes a new profile id to track the up-to-date-ness of another client.
  def generate_profile_id
    if not too_many_ids
      self.profile_ids.create :emailaccount_type => 'listed'
    end
  end

  def set_group param
    return nil if param.nil?
    group = Group.find(param)
    self.group = group || Group.default_group
  end

  # Sets the configuration of the emailaccount
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

  # Checks if the provided key can be handled by the FileCreator
  def valid_key? key
    key and (FileCreator::valid_key?(key.to_sym))
  end

  # Ensures that the zip file is up to date.
  def assure_created_zip
    FileCreator::createNewZip(self)
    raise "No file created" unless File.exists? zip_path
  end

  # ensures that the zip file exists and gives the path to it
  def assure_zip_path
    assure_created_zip
    zip_path
  end

  def zip_path
    FileCreator::completeZipPath self
  end


  # the preferences merged with the group's
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

  # Part of the Composite Pattern that can update the whole dependency tree if necessary.
  def propagate_update
    self.preferences = self.group.preferences if self.group
    raise "Couldn't save" unless self.save
    assure_created_zip
  end

 def outdated?
   outdated = self.profile_ids.any? { |p| p.outdated? }
   raise "Couldn't save" unless self.save
   outdated
 end

  # gives the fully instanciated template of the signature (@see EmailaccountHelper)
  def signature
    template = preferences[:signature] or ""
    dict = TemplateHelper::make_dict self.informations
    sig = TemplateHelper::instanciate_template template, dict
  end
end

