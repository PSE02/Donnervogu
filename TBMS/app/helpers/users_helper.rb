# With the help of the CSVImport module you're able to import
# Emailaccounts and groups into your Database.
# All it takes is a valid csv File with at least 2 columns
#               Emailaccount, domain 
#
# Author::    Sascha Schwaerzler, Dominique Rahm
# License::   Distributes under the same terms as Ruby

module UsersHelper
  module CSVImport
    def  self.import filedata
      csv = CSV.parse(filedata)
      csv.delete_at(0)
      csv\
        .collect {|e| [e[0], e[1]]}\
          .each do |email, domain|
            raise "domain is nil" if domain.nil?
            raise "email is nil" if email.nil?
            init(email, domain)
          end
    end
         
    def self.init email, domain
      group = initGroup(domain) 
      initAccount(email, group)
    end
     
    def self.initAccount email, group
       newAccount = Emailaccount.new
       newAccount.email = email
       newAccount.name = email.split(/@/)[0]
       newAccount.group = group
       newAccount.save
    end 
    
    def self.initGroup domain
      domain = domain.split(/\./)[0]
      group = Group.find_by_name(domain)
      if group.nil? 
        group = Group.new
        group.name = domain
        group.save
      end 
      return group
    end
 end
end
