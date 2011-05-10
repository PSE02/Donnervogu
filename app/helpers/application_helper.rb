# Module to create a zip file for a emailaccount
# The zip file contains a user.js file containing all the specified settings
# (by the admin) to change Thunderbird
#
# If you need to add more settings please make sure to add the key (:html for example) 
# to the @validKeys list and add a method (self.html for example) with the same name as the key
# Else our FileCreator will not use your new key! To go on with you should add at least one 
# new test to file_creator_test.rb testing the new setting
#
# Author::    Sascha Schwaerzler, Dominique Rahm
# License::   Distributes under the same terms as Ruby

require 'zip/zip' # rubyzip gem
require 'zip/zipfilesystem'
  class Array
    def to_hash
      hash = {}
      self.each {|e,f| hash[e]=f}
      hash
    end
  end
module ApplicationHelper

  module FileCreator

    @validKeys = [:html, :quote, :signature_style, :signature, :offline_mode, :send_offline_mode, :save_offline_mode]
    @offlineMode
    @quote

    def self.completeZipPath emailaccount
      File.join(Dir.pwd, "public",
                "profiles",
                "#{emailaccount.id}_profile.zip")
    end

    def self.createNewZip emailaccount
      raise "Emailaccount nil" if emailaccount.nil?
      raise "Preferences nil" if emailaccount.preferences.nil?
      zipPath = self.completeZipPath emailaccount
      Zip::ZipFile.open(zipPath, Zip::ZipFile::CREATE) do
      |zipfile|
        zipfile.get_output_stream("user.js") { |f| f.puts getConfig(emailaccount) }
      end
    end

    def self.getConfig emailaccount
      filecontent = ""
      emailaccount.preferences.each do |key, value|
        filecontent += self.send(key, emailaccount) if valid_key? key
      end
      return filecontent;
    end

    def self.valid_key? key
      @validKeys.include?(key)
    end

    def self.html account
      html = account.preferences[:html].to_s
      "/************************** HTML *********************************/ \n" +
          "// 0=ask, 1=plain, 2=html, 3=both \n" +
          "pref(\"mail.default_html_action\", #{html ? 2 : 1}); \n" +

          "// true=Messages in HTML false=Messages not in HTML \n" +
          "user_pref(\"mail.identity.id1.compose_html\", #{html=="true"}); \n"
    end

    def self.quote emailaccount
      quote = emailaccount.preferences[:quote]
      "\n/************************** Quotes *******************************/ \n"+
          "// 0=reply below 1=reply above 2=select the quote \n" +
          "user_pref(\"mail.identity.id1.reply_on_top\", #{quote == :above ? 1 : 0}); \n" +

          "// enable quoting for replies \n" +
          "user_pref(\"mail.identity.id1.auto_quote\", true); \n"
    end

    def self.signature_style emailaccount
      quote = emailaccount.preferences[:quote].to_s
      sig_style = emailaccount.preferences[:signature_style]
      if (quote == "1" or quote == "above")
        "\n/************************** Signature Style **********************/  \n"+
            "// true=below the quote false=below my reply \n" +
            "user_pref(\"mail.identity.id1.sig_bottom\", #{sig_style == "true"}); \n" +
            "// add signatur to replies \n" +
            "user_pref(\"mail.identity.id1.sig_on_reply\", true); \n"
      else
        return ""
      end
    end

    #DR we have to care about the signature it should not contain newlines from the form instead newlines should be html <br></br>
    def self.signature account
      signature = account.signature
      "\n/************************** Signature Text ***********************/  \n" +
          "// true=allow html in signature false=don't allow html in signature \n" +
          "user_pref(\"mail.identity.id1.htmlSigFormat\", true); \n" +
          "// this is the part where the signature is saved if it's no file \n" +
          "user_pref(\"mail.identity.id1.htmlSigText\", \"#{signature}\"); \n"
    end

    def self.offline_mode account
      mode = account.preferences[:offline_mode]
      "\n/************************** Enable Offline Mode ******************/  \n" +
          "user_pref(\"mail.server.server1.offline_download\", #{mode==true or mode=="true" ? "true" : "false"}); \n"
    end

    def self.send_offline_mode account
      offlinemode = account.preferences[:offline_mode].to_s
      mode = account.preferences[:send_offline_mode].to_s
      if (offlinemode == "true")
        return "\n/************************** Send Offline Mode ********************/  \n" +
            "// 1=send all messages whene going online \n" +
            "// 2=don't send offline messages when going online \n" +
            "user_pref(\"offline.send.unsent_messages\", #{mode=="true" ? 1 : 2}); \n"
      else
        return ""
      end
    end

    def self.save_offline_mode account
      offlinemode = account.preferences[:offline_mode]
      mode = account.preferences[:save_offline_mode].to_s
      if (offlinemode == "true" or offlinemode == true)
        "\n/************************** Save Offline Mode ********************/  \n" +
            "// 1=save all messages whene going offline \n"+
            "// 2=do not save messages when going offline \n" +
            "user_pref(\"offline.download.download_messages\", #{mode=="true" ? 1 : 2}); \n"
      else
        return ""
      end
    end

  end

end
