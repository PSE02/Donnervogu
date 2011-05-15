# Distinct Ids and the information, when a Profile whas last downloaded.
# The ids correspond to an email client that requests the configuration
# zip regularly.
# Author:: Aaron Karper <akarper@students.unibe.ch>
class ProfileId < ActiveRecord::Base
    belongs_to :emailaccount
  def initialize params={}
    super params
    self.time_of_last_ok = Time.now
    self.time_of_last_connection = Time.now
  end

  def self.count_outdated id = nil
    self.where("time_of_last_ok <= ?", (Time.now - self.threshold_for_oldest_ok)).group(:emailaccount_id).count.size # outdated email accounts, not outdated profile ids
  end

  def self.oldest_profile_config id
    self.where(:emailaccount_id => id).minimum(:time_of_last_ok)
  end

  def self.oldest_get
	  self.minimum("time_of_last_ok")
  end

	def downloaded
		self.time_of_last_ok = Time.now
  end

  def assure_zip_path
    self.emailaccount.assure_zip_path
  end

  # Is this account outdated?
  def outdated?
    (Time.now - self.time_of_last_ok) > threshold_for_oldest_ok
  end

  # generic threshold for how long an account can be inactive until
  # it is considered out of date.
  def self.threshold_for_oldest_ok
    4.days
  end
  def threshold_for_oldest_ok
    self.class.threshold_for_oldest_ok
  end
  
  # generic threshold for how long an account can be inactive until
  # it is considered offline
  def threshold_for_offline
    4.days
  end
  
  # Is this account outdated?
  def online?
    return (Time.now - self.time_of_last_connection) > threshold_for_offline
  end

end
