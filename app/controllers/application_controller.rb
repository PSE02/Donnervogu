# Author :: Dominique Rahm, Aaron Karper, Jonas Ruef
# Basic controller for the application.
# Provides the standard view of the application and allows the user to login/logout.
# It also provides some methods used by all controllers.
class ApplicationController < ActionController::Base
  #Throws a ActionController::InvalidAuthenticityToken exception when requests token doesn't match the current secret token.
  protect_from_forgery :secret => @secret_key

  #Catch and render ActionController::InvalidAuthenticityToken exception
  rescue_from ActionController::InvalidAuthenticityToken, :with => :forgery_error
  def
    forgery_error(exception); render :text => exception.message;
  end

	before_filter :require_user
	before_filter :overview

	filter_parameter_logging :password, :password_confirmation 
	helper_method :current_user_session, :current_user

	def overview
		@emailaccount_size = Emailaccount.count
		@total_outdated    = ProfileId.count_outdated
	end

	def index
	end

	def logged_in?
    current_user
	end

	# Returns true if a current user session object exists.
	def current_user_session

    unless @exists_current_user_session
      @exists_current_user_session = UserSession.find
    end
    @exists_current_user_session
	end

	# Returns current logged in user
	def current_user
   unless @current_user
      # Is true when there is a current user session and it has a user.
      @current_user = current_user_session && current_user_session.user
   end
   @current_user
	end

	# Makes a view only accessible if you are a logged in user
	def require_user
		unless current_user
			store_location
			redirect_to new_user_session_url
		  false
		end
	end

	# Makes a view accessable to logged in and not logged in user
	def require_no_user
		if current_user
			store_location
			redirect_to account_url
		  false
		end
	end

	# Store the URI of the current request in session
	def store_location
		session[:return_to] = request.request_uri
	end

	# Redirect to the URI stored by the most recent store_location call or to the passed default
	def redirect_back_or_default(default)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end
end
