class HomeController < ApplicationController
   require 'rubygems'
   def index
   end

   def configureProfile
       html = params[:html]
       signature = params[:signature]  
       @fc = FileCreator.new
       @fc.createNewZip(html, signature )
   end
end
