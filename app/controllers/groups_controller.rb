# Groups are a collection of emailaccounts that belong and are
# handled together. They have preferences and can overwrite
# the preferences of the users.
# This controller can only be used when logged in as admin.
class GroupsController < ApplicationController
  
  # Restricts access for every method in this controller to logged in user only.
  before_filter :require_user
  before_filter :group_by_id, :only => [:show, :edit, :set_params, :update,
                                        :destroy, :overwrite_member_configs]

  # helper that provides a group for the commands.
  def group_by_id
    @profile = Group.find(params[:id])
    raise "No Group found" if @profile.nil?
  end

  # GET /groups
  # GET /groups.xml
  def index
    @profiles = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @profile = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.xml
  def create
    @profile = Group.new(params[:group])

    respond_to do |format|
      if @profile.save
        format.html { redirect_to(@profile, :notice => 'Group was successfully created.') }
        format.xml  { render :xml => @profile, :status => :created, :location => @profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    respond_to do |format|
      if @profile.update_attributes(params[:group])
        format.html { redirect_to(@profile, :notice => 'Group was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end

  def set_params
    @group = Group.find(params[:id])
    raise "No Group found" if @group.nil?
    @group.set_params(params)
    redirect_to group_path, :notice => 'Settings for this group were successfully saved.'
  end

  # Overwrite the users configuration with the own preferences.
  def overwrite_member_configs
    @profile.propagate_update
    redirect_to group_path, :notice => 'Settings propagated for all members'
  end
end
