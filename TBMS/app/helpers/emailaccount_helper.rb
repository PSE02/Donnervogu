require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'

module EmailaccountHelper
  module FileCreator 
  
    @validKeys = [:html, :quote, :signature_style, :signature]
    
    #DR we have to refactor this to simple pass an array or a email (email would be even better!)
  	def self.createNewZip emailaccount
  		zipPath = Dir.pwd + "/public/profiles/#{emailaccount.id}_profile.zip"
  		Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
  			|zipfile|
  			zipfile.get_output_stream("user.js") { |f| f.puts getConfig(emailaccount)}  
  		end
  	end
  
  	def self.getConfig emailaccount
  	  raise "Emailaccount nil" if emailaccount.nil?
  	  raise "Preferences nil" if emailaccount.preferences.nil?
  	  filecontent = ""
  	  emailaccount.preferences.each do |key, value|
  	    filecontent += self.send(key, value)
  	  end
  		return filecontent
  	end
  	 
	def self.validKey? key
	    @validKeys.include?(key)
        end
  
  	#DR I love string interpolation! we don't need the XML anymore!
  	#DR I think all this stuff will need some refactoring sooner or later!
  	def self.html html
  		htmlContent =  "/************************** HTML *********************************/ \n" +
  		"// 0=ask, 1=plain, 2=html, 3=both \n" +
  		"pref(\"mail.default_html_action\", #{html == "true" ? 2 : 1}); \n" +
  	
  	  "// true=Messages in HTML false=Messages not in HTML \n" +
      "user_pref(\"mail.identity.id1.compose_html\", #{html == "true"}); \n"
  		return htmlContent
  	end
    
     def self.quote quote
       quoteContent = "\n/************************** Quotes *******************************/ \n"+
       "// 0=reply below 1=reply above 2=select the quote \n" +
       "user_pref(\"mail.identity.id1.reply_on_top\", #{quote}); \n" +
       
       "// enable quoting for replies \n" +
       "user_pref(\"mail.identity.id1.auto_quote\", true); \n"
       return quoteContent
     end
  
    def self.signature_style sig_style
      sig_styleContent = "\n/************************** Signature Style **********************/  \n"+
      "// true=below the quote false=below my reply \n" +
      "user_pref(\"mail.identity.id1.sig_bottom\", #{sig_style == "true"}); \n" +
      "// add signatur to replies \n" +
      "user_pref(\"mail.identity.id1.sig_on_reply\", true); \n"
      return sig_styleContent
    end
  
    #DR we have to care about the signature it should not contain newlines from the form instead newlines should be html <br></br>
    def self.signature signature
      signatureContent = "\n/************************** Signature Text ***********************/  \n" +
      "// true=allow html in signature false=don't allow html in signature \n" +
      "user_pref(\"mail.identity.id1.htmlSigFormat\", true); \n" +
      "// this is the part where the signature is saved if it's no file \n" +
      "user_pref(\"mail.identity.id1.htmlSigText\", \"#{signature}\"); \n"
      return signatureContent
    end
    
  end

end
