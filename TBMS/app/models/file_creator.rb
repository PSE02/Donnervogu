require 'rubygems'
require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

class FileCreator < ActiveRecord::Base
	def createNewZip(isSet)
		zipPath = Dir.pwd + "/public/profiles/profile.zip"
		if isSet == true
		  	Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) {
		   	|zipfile|
		   	zipfile.get_output_stream("user.js") { |f| f.puts "Hallo this is 
			a first test creating zips with ruby!" }  
		   }
		else
			Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) {
		   	|zipfile|
		   	zipfile.get_output_stream("user.js") { |f| f.puts "Hallo this is 
			a first test creating zips with ruby! --- noooot!" }  
		   }
		end
	end
end
