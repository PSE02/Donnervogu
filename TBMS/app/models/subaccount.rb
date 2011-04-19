# Distinct Ids and the information, when a Profile whas last downloaded.
class Subaccount < ActiveRecord::Base
  belongs_to :emailaccount
  def initialize params={}
    super params
    self.last_get = Time.now
  end

  def self.oldest_subaccount_config id
    self.where(:emailaccount_id => id).minimum(:last_get)
  end

  def self.oldest_get
	  self.minimum("last_get")
  end

	def downloaded
		self.last_get = Time.now
  end

  def assure_zip_path
    self.emailaccount.assure_zip_path
  end

  # Is this account outdated?
  def outdated?
    (Time.now - oldest_subaccount_config) > threshold_for_oldest_get
  end

  # generic threshold for how long an account can be inactive until
  # it is considered out of date.
  def threshold_for_oldest_get
    4.days
  end
end
