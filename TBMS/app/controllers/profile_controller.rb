class ProfileController < ApplicationController
   # Restricts access for every method in this controller to logged in user only.
   before_filter :require_user
	
	def zip
		redirect_to :controller => :emailaccounts, :action => :zipOf
	end
end
