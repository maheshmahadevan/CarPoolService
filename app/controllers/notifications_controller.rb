class NotificationsController < ApplicationController
def index       
   @notifications = Notification.find(:all)       
   respond_to do |format|         
     format.xml { render :xml => @notifications.to_xml }         
     format.html { }       
   end     
   end
	
   def show       
   @notification = Notification.find(params[:id])       
   respond_to do |format|         
     format.xml { render :xml => @notification.to_xml }         
     format.html { }       
    end     
   end
   
   # GET - displays a form which can be used to create a post     
 def new       
   @notification = Notification.new     
 end
   
   # POST - create a new post     
  def create       
   @notification = Notification.new(params[:notification])       
   @notification.save!        
  
   respond_to do |format|         
     format.html { redirect_to notification_path(@notification) }         
     format.xml { render :xml => @notification.to_xml,   
       :status => :created }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'new' }         
     format.xml { render :xml => @notification.errors.to_xml,   
       :status => 500 }       
    end     
   end 
   
   # GET - displays a form allowing us to edit an existing post     
 def edit       
   @notification = Notification.find(params[:id])     
 end      
  
 # PUT - update an existing post     
 def update       
   @notification = Notification.find(params[:id])       
   @notification.attributes = params[:notification]       
   @notification.save!        
  
   respond_to do |format|         
     format.html { redirect_to notification_path(@notification) }         
     format.xml { render :xml => @notification.to_xml,   
       :status => :ok }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'edit' }         
     format.xml { render :xml => @notification.errors.to_xml,   
       :status => 500 }       
   end     
 end      
  
 # DELETE - delete a post     
 def destroy       
   @notification  = Notification.find(params[:id])       
   @notification.destroy       
   respond_to do |format|         
     format.html { redirect_to notifications_path }         
     format.xml { head :ok }       
   end     
 end 
end
