$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'bundler/capistrano'
require 'rvm/capistrano'
set :application, "tbms"

#rvm
set :rvm_ruby_string, 'ruby-1.9.2-p136'
set :rvm_type, :user

#Repository
set :repository, "git://github.com/fadendaten/Donnervogu.git"
set :scm, :git
set :branch, "master"

#Server
role :web, ###--> Insert your server ip <--###     # Your HTTP server, Apache/etc
role :app, ###--> Insert your server ip <--###     # This may be the same as your `Web` server
role :db,  ###--> Insert your server ip <--###     # This is where Rails migrations will run

# Server details
set :deploy_to, "/home/nile/tbms/htdocs/#{application}"
set :deploy_via, :copy
set :use_sudo, false
set :user, ###--> Insert your User <--###
set :port, ###--> Insert your PW <--###
set :password, ###--> Insert your PW <--###

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  task :symlink_shared do
	# Symlink to database.yml
   	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	# Symlink to forgery_secret_key
   	run "ln -nfs #{shared_path}/config/forgery_secret_key #{release_path}/config/forgery_secret_key"
	# Symlink to secret_token.rb
	run "ln -nfs #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
	# Symlink to seeds.rb -- This is for the adminaccount: current user:admin, pw:shuSh8Mi
	run "ln -nfs #{shared_path}/db/seeds.rb #{release_path}/db/seeds.rb"
  end

	task :tbms_setup do
		run "mkdir -p #{release_path}/public/profiles/log"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end

namespace :tbms_users do
	task :new do
		
	end
end

# HOOKS
after "deploy:update_code" do
  bundler.bundle_new_release
  deploy.symlink_shared
	deploy.tbms_setup
	db.seed
end
#==========================================================================
# Manual Tasks                                                            =
#==========================================================================
namespace :db do
 desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end

 desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end

 desc "Setup Production Database"
    task :setup do
      puts "\n\n=== Setup the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:setup RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end

 desc "Rest Production Database"
    task :reset do
      puts "\n\n=== Setup the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:reset RAILS_ENV=production"
      #system "cap deploy:set_permissions"
    end
end
