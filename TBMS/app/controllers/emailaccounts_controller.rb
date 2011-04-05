class EmailaccountsController < ApplicationController
	before_filter :require_user, :except => [ :zipOf ]
  # GET /emailaccounts
  # GET /emailaccounts.xml
  def index
    @emailaccounts = Emailaccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emailaccounts }
    end
  end

  # GET /emailaccounts/1
  # GET /emailaccounts/1.xml
  def show
    @emailaccount = Emailaccount.find(params[:id])

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
    @emailaccount = Emailaccount.find(params[:id])

    respond_to do |format|
      if @emailaccount.update_attributes(params[:emailaccount])
        format.html { redirect_to(@emailaccount, :notice => 'Emailaccount was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @emailaccount.errors, :status => :unprocessable_entity }
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

  def setParams
    @emailaccount = Emailaccount.find(params[:id])
    raise "No Account found" if @emailaccount.nil?
    @emailaccount.setParams(params)
    redirect_to emailaccount_path, :notice => 'Settings for this account were successfully saved.'
  end
  
  def validInput emailaccount
    return emailaccount[:email].match("@")
  end 

  def zipOf
	  emailaccount = Emailaccount.find_by_email params[:email] 
	  raise "No such account" if emailaccount.nil?
	  #DR we have to change this here, if we get a response from the plugin the emailaccount.downloaded is called
	  emailaccount.downloaded
	  send_file emailaccount.assureZipPath
  end
end
