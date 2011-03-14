#!/usr/bin/ruby1.9.1

require 'zip/zip'
require 'zip/zipfilesystem'

def createNewUserFile
	zipPath = Dir.pwd + "/profile.zip"
	filePath = Dir.pwd + "/user.js"

   Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) {
   	|zipfile|
   	zipfile.get_output_stream("user.js") { |f| f.puts "Hallo this is 
	a first test creating zips with ruby!" }  
   }
end
	
	
if __FILE__ == $0
	createNewUserFile
end




