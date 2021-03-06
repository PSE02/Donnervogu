# Handles the interaction with the emailaccounts.
# This includes
#     * CRUD
#     * Providing the zips
#     * Handing out identifying ids
#     * Management of the user's configuration
# All actions except for getting the zip require the admin to be logged in.
class EmailaccountsController < ApplicationController
	#Throws a ActionController::InvalidAuthenticityToken exception when requests token doesn't match the current secret token.
  protect_from_forgery :secret => @secret_key

  #Catch and render ActionController::InvalidAuthenticityToken exception
  rescue_from ActionController::InvalidAuthenticityToken, :with => :forgery_error
  def
    forgery_error(exception); render :text => exception.message;
  end
  
  before_filter :require_user, :except => [ :zip_of_id, :zip_of_email ]
  before_filter :emailaccount_by_id, :only => [:show, :update,
                                               :destroy,
                                               :set_params, :group_configuration,
                                                :change_information]


  # helper that provides all methods with an emailaccount
  def emailaccount_by_id
    @profile = Emailaccount.find(params[:id])
    raise "No such Emailaccount #{id}!" if @profile.nil?
  end
  # Paginates and shows the emailaccounts.
  # GET /emailaccounts
  # GET /emailaccounts.xml
  def index
    @search = Emailaccount.search(params[:search])
    @profiles = @search.page(params[:page]).per(20)
    errors = @profiles.select { |e| e.standard_subaccount.nil? }
    if not errors.empty?
      raise errors.inject("") {|e,f| e + "\nno standard profileid for email #{f.email}"}
    end
    respond_to do |format|
      format.html # index.html.haml
      format.xml  { render :xml => @profiles }
    end
  end

  def not_modified
  end

  # Shows a single emailaccount
  # GET /emailaccounts/1
  # GET /emailaccounts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @profile }
    end
  end

  # Shows the interface for new Emailaccounts
  # GET /emailaccounts/new
  # GET /emailaccounts/new.xml
  def new
    @profile = Emailaccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # POST /emailaccounts
  # POST /emailaccounts.xml
  def create
    @profile = Emailaccount.new(params[:emailaccount])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to(@profile, :notice => 'Emailaccount was successfully created.') }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emailaccounts/1
  # PUT /emailaccounts/1.xml
  def update
    respond_to do |format|
      if @profile.update_attributes(params[:emailaccount])
        format.html { redirect_to(@profile, :notice => 'Emailaccount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /emailaccounts/1
  # DELETE /emailaccounts/1.xml
  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(emailaccounts_url) }
      format.xml  { head :ok }
    end
  end

  def set_params
    @profile.set_group params[:group]
    @profile.set_params(params)
    redirect_to emailaccount_path, :notice => "Settings for this account were successfully saved."
  end

  # Get the configuration zip and a header with a brand new id.
  def zip_of_email
    @profile = Emailaccount.find_by_email(params[:email])
    response.headers["X-TBMS-Profile-ID"] = @profile.generate_profile_id.to_s
    zip_path = @profile.assure_zip_path
	  send_file zip_path
  end

  # Get the configuration zip.
  def zip_of_id
    cacheTime = Time.rfc2822(request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    if request.headers['X-TBMS-Status'] == "false"
      redirect_to status_path(params[:id])
    end
    emailaccount = ProfileId.find(params[:id]).emailaccount

    if not modified(emailaccount)
      render :nothing => true, :status => 304
    else
      response.headers['Last-Modified'] = emailaccount.updated_at.httpdate
      zip_path = emailaccount.assure_zip_path
      send_file zip_path
    end
  end

    def modified(emailaccount)
      return true unless request.headers.include? 'If-Modified-Since'
      since_date = Time.parse request.headers['If-Modified-Since']

      last_modification = emailaccount.updated_at
      return true if last_modification.nil?

      since_date < last_modification
    end

  # tells the server, that the configuration was successfully received.
  def was_successfully_updated
    subaccount = ProfileId.find(params[:id])
    subaccount.downloaded
  end

  # Propagates the groups configuration to this account.
  def group_configuration
    @profile.propagate_update
    redirect_to emailaccount_path, :notice => "Reset Account settings to groups"
  end

  # What it says on the tin
  def delete_subaccount
    subaccount = ProfileId.find(params[:id])
    raise "No such subaccount" if subaccount.nil?
    emailaccount = subaccount.emailaccount
    subaccount.destroy
    respond_to do |format|
      format.html { redirect_to(emailaccount_path(emailaccount), :notice => "Deleted ProfileId") }
      format.xml  { head :ok }
    end
  end

  def change_information
    keys = params\
                    .select {|key,val| /key_\d+/.match(key) and val.present?}\
                    .collect {|key,val| [(/key_\d+/.match(key))[1].to_i, val.to_sym]}\
                    .sort_by {|key,val| key}\
                    .collect {|key,val| val}
    values = params\
                    .select {|key,val| /value_\d+/.match(key) and val.present?}\
                    .collect {|key,val| [(/value_\d+/.match(key))[1].to_i, val]}\
                    .sort_by {|key,val| key}\
                    .collect {|key,val| val}
    key_values = keys.zip(values).to_hash
    @profile.informations= key_values
    raise "Couldn't save profile #{@profile.email}:\n* #{@profile.errors[:base].join '\n* '}" unless @profile.save
    redirect_to emailaccount_path, :notice => "Settings for this account were successfully saved."
  end

end
