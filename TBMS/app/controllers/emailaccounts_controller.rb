class EmailaccountsController < ApplicationController
	before_filter :require_user, :except => [ :zip_of_id, :zip_of_email ]
  # GET /emailaccounts
  # GET /emailaccounts.xml
  def index
    @emailaccounts = Emailaccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emailaccounts }
    end
  end

  def not_modified
  end

  # GET /emailaccounts/1
  # GET /emailaccounts/1.xml
  def show
    @profile = Emailaccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @emailaccount }
    end
  end

  # GET /emailaccounts/new
  # GET /emailaccounts/new.xml
  def new
    @emailaccount = Emailaccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @emailaccount }
    end
  end

  # POST /emailaccounts
  # POST /emailaccounts.xml
  def create
    @emailaccount = Emailaccount.new(params[:emailaccount])

    respond_to do |format|
      if @emailaccount.save
        format.html { redirect_to(@emailaccount, :notice => 'Emailaccount was successfully created.') }
        format.xml  { render :xml => @emailaccount, :status => :created, :location => @emailaccount }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @emailaccount.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /emailaccounts/1
  # PUT /emailaccounts/1.xml
  def update
    @profile = Emailaccount.find(params[:id])
    raise "No such account #{params[:id]}" if @profile.nil?
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
    @emailaccount = Emailaccount.find(params[:id])
    @emailaccount.destroy

    respond_to do |format|
      format.html { redirect_to(emailaccounts_url) }
      format.xml  { head :ok }
    end
  end

  def set_params
    @emailaccount = Emailaccount.find(params[:id])
    raise "No Account found" if @emailaccount.nil?
    @emailaccount.set_group params[:group]
    @emailaccount.set_params(params)
    redirect_to emailaccount_path, :notice => "Settings for this account were successfully saved."
  end

  def zip_of_email
	  emailaccount = Emailaccount.find_by_email params[:email]
	  raise "No such account" if emailaccount.nil?
    response.headers["X-TBMS-Profile-ID"] = emailaccount.generate_subaccount.to_s
    zip_path = emailaccount.assure_zip_path
	  send_file zip_path
  end

  def zip_of_id
    cacheTime = Time.rfc2822(@request.env["HTTP_IF_MODIFIED_SINCE"]) rescue nil
    emailaccount = Subaccount.find(params[:id]).emailaccount
    raise "No such account" if emailaccount.nil?
    if cacheTime and emailaccount.updated_at <= cacheTime
      return render :nothing => true, :status => 304
    else
      @response.headers['Last-Modified'] = emailaccount.updated_at.httpdate
      zip_path = emailaccount.assure_zip_path
      send_file zip_path
    end
  end

  def was_successfully_updated
    subaccount = Subaccount.find(params[:id])
    subaccount.downloaded
  end
end
