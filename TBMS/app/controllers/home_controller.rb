class HomeController < ApplicationController
	require 'rubygems'
	def index
	end

	def setHtml
		set = params[:set]
		@fc = FileCreator.new
		if set == "true"
			@fc.createNewZip(true)
		else
			@fc.createNewZip(false)
		end
	end
end
