class LogMessage < ActiveRecord::Base
  belongs_to :profile, :class_name => "ProfileId"

end
