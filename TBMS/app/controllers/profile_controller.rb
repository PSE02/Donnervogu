class ProfileController < ApplicationController
	def zip
		redirect_to :controller => :emailaccounts, :action => :zipOf
	end
end
