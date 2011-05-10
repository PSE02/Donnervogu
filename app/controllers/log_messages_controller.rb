
# This Controller handles everything that logs the reports of
# the plugins on errors. It is not involved in the program flow,
# if no exception occurs.
#
# Author:: Aaron Karper <akarper@students.unibe.ch>
class LogMessagesController < ApplicationController
  before_filter :require_user, :except => [:handle]
  # GET /log
  # GET /log.xml
  def index
    @log_messages = LogMessage.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.haml
      format.xml { render :xml => @log_messages }
    end
  end

  # GET /log/1
  # GET /log/1.xml
  def show
    @log_message = LogMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml { render :xml => @log_message }
    end
  end


  # DELETE /log/1
  # DELETE /log/1.xml
  def destroy
    @log_message = LogMessage.find(params[:id])
    @log_message.destroy

    respond_to do |format|
      format.html { redirect_to(log_messages_url) }
      format.xml { head :ok }
    end
  end

  # Can be called by anyone on the internet and logs their error message
  # into the database.
  # Uses headers for status reports.
  # GET /log/handle/1
  # GET /status/1
  def handle
    profile = ProfileId.find(params[:id])
    if request.headers['X-TBMS-Status'] == "false"
      log = LogMessage.new
      log.message = request.headers['X-TBMS-Status-Msg']
      log.profile = profile
      log.save
      render :nothing => true, :status => :ok
    else
      render :nothing => true, :status => :ok
    end
  end

end
