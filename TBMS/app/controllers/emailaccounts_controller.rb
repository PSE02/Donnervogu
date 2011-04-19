class EmailaccountsController < ApplicationController
	before_filter :require_user, :except => [ :zip_of_id, :zip_of_email ]
  before_filter :emailaccount_by_id, :only => [:show, :update,
                                               :destroy,
                                               :set_params, :group_configuration]

  def emailaccount_by_id
    @profile = Emailaccount.find(params[:id])
    raise "No such Emailaccount #{id}!" if @profile.nil?
  end
  # GET /emailaccounts
  # GET /emailaccounts.xml
  def index
    @profiles = Emailaccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /emailaccounts/1
  # GET /emailaccounts/1.xml
  def show
    @profile = Emailaccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

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
    response.headers["X-TBMS-Profile-ID"] = @profile.generate_subaccount.to_s
    zip_path = @profile.assure_zip_path
	  send_file zip_path
  end

  # Get the configuration zip.
  def zip_of_id
    emailaccount = Subaccount.find(params[:id]).emailaccount
	  raise "No such account" if emailaccount.nil?
    zip_path = emailaccount.assure_zip_path
    send_file zip_path
  end

  # tells the server, that the configuration was successfully got.
  def was_successfully_updated
    subaccount = Subaccount.find(params[:id])
    subaccount.downloaded
  end

  # Propagates the groups configuration to this account.
  def group_configuration
    @profile.propagate_update
    redirect_to emailaccount_path, :notice => "Reset Account settings to groups"
  end
end
