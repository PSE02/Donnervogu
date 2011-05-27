# Author :: Jonas Ruef
# Manages the user session: When logging in create a new session object,
# when logging out destroy the session object.
class UserSessionsController < ApplicationController
	# Throws a ActionController::InvalidAuthenticityToken exception when requests token doesn't match the current secret token.
  protect_from_forgery :secret => @secret_key

  # Catch and render ActionController::InvalidAuthenticityToken exception
  rescue_from ActionController::InvalidAuthenticityToken, :with => :forgery_error
  def
    forgery_error(exception); render :text => exception.message;
  end

	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => :destroy
	
	# Creates a new empty session object
	def new
    # Generate new session id to prevent session fixation attacks.
    reset_session
		@user_session = UserSession.new
	end

	# Setting up the user session
	def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default root_url
		else
			render :action => :new
		end
	end

	# Destroys the user session object when logging out
	def destroy
    current_user_session.destroy
		redirect_to root_url
	end
end