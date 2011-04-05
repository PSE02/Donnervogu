# Author :: Jonas Ruef
# Manages the sessions
class UserSessionsController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => :destroy
	
	# Creates a new empty session
	def new
		@user_session = UserSession.new
	end

	# Setting up the user session
	def create
		@user_session = UserSession.new(params[:user_session])
		if @user_session.save
			redirect_back_or_default 'index#show'
		else
			render :action => :new
		end
	end

	# Destroys the user when logging out
	def destroy
		current_user_session.destroy
		redirect_to root_url
	end
end