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
end
