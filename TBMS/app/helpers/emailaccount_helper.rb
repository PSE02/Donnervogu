require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

module EmailaccountHelper
  module FileCreator 
  
    @validKeys = [:html, :quote, :signature_style, :signature, :offline_mode, :send_offline_mode, :save_offline_mode]
    @offlineMode
    @quote 
    #DR we have to refactor this to simple pass an array or a email (email would be even better!)
    
    def self.completeZipPath emailaccount
	    File.join(Dir.pwd,"public",
		      "profiles",
		      "#{emailaccount.id}_profile.zip")
    end

  	def self.createNewZip emailaccount
      raise "Emailaccount nil" if emailaccount.nil?
      raise "Preferences nil" if emailaccount.preferences.nil?
  		zipPath = self.completeZipPath emailaccount
  		Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
  			|zipfile|
  			zipfile.get_output_stream("user.js") { |f| f.puts getConfig(emailaccount)}  
  		end
  	end
  
  	def self.getConfig emailaccount
  	  filecontent = ""
  	  emailaccount.preferences.each do |key, value|
  	    filecontent += self.send(key, value) if validKey? key
  	  end
  	  return filecontent;
  	end
  	 
    def self.validKey? key
	    @validKeys.include?(key)
    end
  
  	#DR I love string interpolation! we don't need the XML anymore!
  	#DR I think all this stuff will need some refactoring sooner or later!
  	def self.html html
  		"/************************** HTML *********************************/ \n" +
  		"// 0=ask, 1=plain, 2=html, 3=both \n" +
  		"pref(\"mail.default_html_action\", #{html == "true" ? 2 : 1}); \n" +
  	
  	  "// true=Messages in HTML false=Messages not in HTML \n" +
      "user_pref(\"mail.identity.id1.compose_html\", #{html == "true"}); \n"
  	end
    
     def self.quote quote
       @quote = quote
       "\n/************************** Quotes *******************************/ \n"+
       "// 0=reply below 1=reply above 2=select the quote \n" +
       "user_pref(\"mail.identity.id1.reply_on_top\", #{quote}); \n" +
       
       "// enable quoting for replies \n" +
       "user_pref(\"mail.identity.id1.auto_quote\", true); \n"
     end
  
    def self.signature_style sig_style
      if (@quote == "1") 
        "\n/************************** Signature Style **********************/  \n"+
        "// true=below the quote false=below my reply \n" +
        "user_pref(\"mail.identity.id1.sig_bottom\", #{sig_style == "true"}); \n" +
        "// add signatur to replies \n" +
        "user_pref(\"mail.identity.id1.sig_on_reply\", true); \n"
      else return ""
      end
    end
  
    #DR we have to care about the signature it should not contain newlines from the form instead newlines should be html <br></br>
    def self.signature signature
      "\n/************************** Signature Text ***********************/  \n" +
      "// true=allow html in signature false=don't allow html in signature \n" +
      "user_pref(\"mail.identity.id1.htmlSigFormat\", true); \n" +
      "// this is the part where the signature is saved if it's no file \n" +
      "user_pref(\"mail.identity.id1.htmlSigText\", \"#{signature}\"); \n"
    end
    
    def self.offline_mode mode
      @offlineMode = mode
      "\n/************************** Enable Offline Mode ******************/  \n" +    
      "user_pref(\"mail.server.server1.offline_download\", #{mode}); \n"
    end
    
    def self.send_offline_mode mode
      if (@offlineMode == "true") 
        return ("\n/************************** Send Offline Mode ********************/  \n" +    
              "// 1=send all messages whene going online \n" +
              "// 2=don't send offline messages when going online \n" +
              "user_pref(\"offline.send.unsent_messages\", #{mode}); \n" )
      else return ""
      end       
    end
    
    def self.save_offline_mode mode
      if (@offlineMode == "true") 
        return ("\n/************************** Save Offline Mode ********************/  \n" +    
       "// 1=save all messages whene going offline \n"+
       "// 2=do not save messages when going offline \n" +
       "user_pref(\"offline.download.download_messages\", #{mode}); \n"  )   
      else return ""
      end
    end
    
  end
end
