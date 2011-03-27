class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_user
  
  filter_parameter_logging :password, :password_confirmation # there are underscores :-|
  helper_method :current_user_session, :current_user

	def index
  end
  
  #DR rename to setParams plix and add routes and it should not create the file but changed the :preferences in the current email
  def setHtml
        html = params[:html]
        quote = params[:quote]
        sig_style = params[:signatur_style]
        signatur = params[:signatur]
        @fc = FileCreator.new
        @fc.createNewZip(html, quote, sig_style, signatur)
   end
   
   def logged_in?
      @current_user
    end

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
end
