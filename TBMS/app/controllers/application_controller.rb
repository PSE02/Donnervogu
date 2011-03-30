class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_user
  before_filter :overview
  
  filter_parameter_logging :password, :password_confirmation # there are underscores :-|
  helper_method :current_user_session, :current_user

  def overview
	  @emailac_count = Emailaccount.count
	  @email_oldest_get = Emailaccount.oldestGet
  end

  def index   
  end
  
  #DR rename to setParams plix and add routes and it should not create the file but changed the :preferences in the current email
  def setHtml
        html = params[:html]
        quote = params[:quote]
        sig_style = params[:signatur_style]
        signature = params[:signature]
        @fc = FileCreator.new
        @fc.createNewZip(html, quote, sig_style, signature)
   end
   
   def logged_in?
      @current_user
   end
    
  private
    #JR Returns current user session, if somebody is logged in
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    #JR Returns current logged in user
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    #JR Makes a view only accessible if you are a logged in user
    def require_user
      unless current_user
        store_location
        redirect_to new_user_session_url
        return false
      end
    end

    #JR Makes a view accessable to logged in and not logged in user
    def require_no_user
      if current_user
        store_location
        redirect_to account_url
        return false
      end
    end

    #JR Store the URI of the current request in session
    def store_location
      session[:return_to] = request.request_uri
    end

    #JR Redirect to the URI stored by the most recent store_location call or to the passed default
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
