class OfferRequestsController < ApplicationController
 def index       
   @offer_requests = OfferRequest.find(:all)       
   respond_to do |format|         
     format.xml { render :xml => @offer_requests.to_xml }         
     format.html { }       
   end     
   end
	
   def show       
   @offer_request = OfferRequest.find(params[:id])
   #@offer_request = OfferRequest.find(params[:startpoint])  
   #if params[:startpoint] and params[:id].nil?
  #OfferRequest.find(:all, :conditions => ["startpoint = ?", params[:startpoint]])
	#elsif params[:startpoint].nil? and params[:id]
  #OfferRequest.find(:all, :conditions => ["id = ?", params[:id]])
	#end
		       
   respond_to do |format|         
     format.xml { render :xml => @offer_request.to_xml }         
     format.html { }       
    end     
   end
   
   def show       
    @offer_request = OfferRequest.find_by_startPoint(params[:startPoint])
	 respond_to do |format|         
     format.xml { render :xml => @offer_request.to_xml }         
     format.html { }       
    end     
   end
   
   # GET - displays a form which can be used to create a post     
 def new       
   @offer_request = OfferRequest.new     
 end
   
   # POST - create a new post     
  def create       
   @offer_request = OfferRequest.new(params[:offer_request])       
   @offer_request.save!        
  
   respond_to do |format|         
     format.html { redirect_to offer_request_path(@offer_request) }         
     format.xml { render :xml => @offer_request.to_xml,   
       :status => :created }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'new' }         
     format.xml { render :xml => @offer_request.errors.to_xml,   
       :status => 500 }       
    end     
   end 
   
   # GET - displays a form allowing us to edit an existing post     
 def edit       
   @offer_request = offer_request.find(params[:id])     
 end      
  
 # PUT - update an existing post     
 def update       
   @offer_request = OfferRequest.find(params[:id])       
   @offer_request.attributes = params[:offer_request]       
   @offer_request.save!        
  
   respond_to do |format|         
     format.html { redirect_to offer_request_path(@offer_request) }         
     format.xml { render :xml => @offer_request.to_xml,   
       :status => :ok }       
   end     
   rescue ActiveRecord::RecordInvalid       
   respond_to do |format|         
     format.html { render :action => 'edit' }         
     format.xml { render :xml => @offer_request.errors.to_xml,   
       :status => 500 }       
   end     
 end      
  
 # DELETE - delete a post     
 def destroy       
   @offer_request  = OfferRequest.find(params[:id])       
   @offer_request.destroy       
   respond_to do |format|         
     format.html { redirect_to offer_requests_path }         
     format.xml { head :ok }       
   end     
 end  
end
