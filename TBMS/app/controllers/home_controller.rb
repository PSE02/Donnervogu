class HomeController < ApplicationController
   require 'rubygems'
   def index
   end

   def setHtml
       set = params[:set]
       @fc = FileCreator.new
       @fc.createNewZip((set))
   end
end
