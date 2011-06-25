class CommunitiesController < ApplicationController
def index       
   @communities = Community.find(:all)       
   respond_to do |format|         
     format.xml { render :xml => @communities.to_xml }         
     format.html { }       
   end     
   end
	
   def show       
   @community = Community.find(params[:id])       
   respond_to do |format|         
     format.xml { render :xml => @community.to_xml }         
     format.html { }       
    end     
   end
   
   # GET - displays a form which can be used to create a post     
 def new       
   @community = Community.new     
 end
   
   # POST - create a new post     
  def create       
   @community = Community.new(params[:community])       
   @community.save!        
  
   respond_to do |format|         
     format.html { redirect_to user_path(@community) }         
     format.xml { render :xml => @community.to_xml,   
       :status => :created }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'new' }         
     format.xml { render :xml => @community.errors.to_xml,   
       :status => 500 }       
    end     
   end 
   
   # GET - displays a form allowing us to edit an existing post     
 def edit       
   @community = Community.find(params[:id])     
 end      
  
 # PUT - update an existing post     
 def update       
   @community = Community.find(params[:id])       
   @community.attributes = params[:community]       
   @community.save!        
  
   respond_to do |format|         
     format.html { redirect_to community_path(@community) }         
     format.xml { render :xml => @community.to_xml,   
       :status => :ok }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'edit' }         
     format.xml { render :xml => @community.errors.to_xml,   
       :status => 500 }       
   end     
 end      
  
 # DELETE - delete a post     
 def destroy       
   @community  = Community.find(params[:id])       
   @community.destroy       
   respond_to do |format|         
     format.html { redirect_to communities_path }         
     format.xml { head :ok }       
   end     
 end 
end
