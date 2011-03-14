class HomeController < ApplicationController
	require 'rubygems'
	def index
	end

	def setHtml
		set = params[:set] 
		if set == "true"
			@fc = FileCreator.new
			@fc.createNewZip
		end
		render :index
	end
end
