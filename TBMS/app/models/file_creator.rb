require 'rubygems'
require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

class FileCreator < ActiveRecord::Base
	def createNewZip
			zipPath = Dir.pwd + "/profile.zip"

		   Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) {
		   	|zipfile|
		   	zipfile.get_output_stream("user.js") { |f| f.puts "Hallo this is 
			a first test creating zips with ruby!" }  
		   }
	end
end
