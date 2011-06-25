class UserCommunitiesController < ApplicationController
def index       
   @user_communities = UserCommunity.find(:all)       
   respond_to do |format|         
     format.xml { render :xml => @user_communities.to_xml }         
     format.html { }       
   end     
   end
	
   def show       
   @user_community = UserCommunity.find(params[:id])       
   respond_to do |format|         
     format.xml { render :xml => @user_community.to_xml }         
     format.html { }       
    end     
   end
   
   # GET - displays a form which can be used to create a post     
 def new       
   @user_community = UserCommunity.new     
 end
   
   # POST - create a new post     
  def create       
   @user_community = UserCommunity.new(params[:user_community])       
   @user_community.save!        
  
   respond_to do |format|         
     format.html { redirect_to user_community_path(@user_community) }         
     format.xml { render :xml => @user_community.to_xml,   
       :status => :created }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'new' }         
     format.xml { render :xml => @user_community.errors.to_xml,   
       :status => 500 }       
    end     
   end 
   
   # GET - displays a form allowing us to edit an existing post     
 def edit       
   @user_community = UserCommunity.find(params[:id])     
 end      
  
 # PUT - update an existing post     
 def update       
   @user_community = UserCommunity.find(params[:id])       
   @user_community.attributes = params[:user_community]       
   @user_community.save!        
  
   respond_to do |format|         
     format.html { redirect_to user_community_path(@user_community) }         
     format.xml { render :xml => @user_community.to_xml,   
       :status => :ok }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'edit' }         
     format.xml { render :xml => @user_community.errors.to_xml,   
       :status => 500 }       
   end     
 end      
  
 # DELETE - delete a post     
 def destroy       
   @user_community  = UserCommunity.find(params[:id])       
   @user_community.destroy       
   respond_to do |format|         
     format.html { redirect_to user_communities_path }         
     format.xml { head :ok }       
   end     
 end
end
