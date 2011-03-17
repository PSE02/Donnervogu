class HomeController < ApplicationController
   require 'rubygems'
   def index
	   @users = User.all
   end

   def setHtml
       set = params[:set]
       @fc = FileCreator.new
       @fc.createNewZip((set))
   end
end
