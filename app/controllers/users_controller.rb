class UsersController < ApplicationController
def index       
   @users = User.find(:all)       
   respond_to do |format|         
     format.xml { render :xml => @users.to_xml }         
     format.html { }       
   end     
   end
	
   def show       
   @user = User.find(params[:id])       
   respond_to do |format|         
     format.xml { render :xml => @user.to_xml }         
     format.html { }       
    end     
   end
   
   # GET - displays a form which can be used to create a post     
 def new       
   @user = User.new     
 end
   
   # POST - create a new post     
  def create       
   @user = User.new(params[:user])       
   @user.save!        
  
   respond_to do |format|         
     format.html { redirect_to user_path(@user) }         
     format.xml { render :xml => @user.to_xml,   
       :status => :created }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'new' }         
     format.xml { render :xml => @user.errors.to_xml,   
       :status => 500 }       
    end     
   end 
   
   # GET - displays a form allowing us to edit an existing post     
 def edit       
   @user = User.find(params[:id])     
 end      
  
 # PUT - update an existing post     
 def update       
   @user = User.find(params[:id])       
   @user.attributes = params[:user]       
   @user.save!        
  
   respond_to do |format|         
     format.html { redirect_to user_path(@user) }         
     format.xml { render :xml => @user.to_xml,   
       :status => :ok }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'edit' }         
     format.xml { render :xml => @user.errors.to_xml,   
       :status => 500 }       
   end     
 end      
  
 # DELETE - delete a post     
 def destroy       
   @user  = User.find(params[:id])       
   @user.destroy       
   respond_to do |format|         
     format.html { redirect_to users_path }         
     format.xml { head :ok }       
   end     
 end

end
