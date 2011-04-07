class HomeController < ApplicationController
   require 'rubygems'
   
   # Restricts access for every method in this controller to logged in user only.
   before_filter :require_user

   def index
	   redirect_to(emailaccounts_path)
   end

   def configureProfile
   end
end
