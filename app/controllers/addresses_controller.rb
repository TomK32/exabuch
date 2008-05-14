class AddressesController < ApplicationController
  before_filter :current_address, :only => [:show, :edit, :update, :destroy, :confirm_destroy]
  def index
    if params[:customer_id].blank?
      @addresses = current_user.user_addresses
    else  
      @addresses = current_user.customers.find(params[:customer_id], :include => :addresses).addresses
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @addresses }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end

  def new
    @address = current_user.addresses.new
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @address }
    end
  end

  def edit
  end

  def create
    if params[:customer_id]
      @address = current_user.customers.find(params[:customer_id]).addresses.new(params[:address].update(:owned_by_user => false))
    else
      @address = current_user.user_addresses.new(params[:address].update(:owned_by_user => true))
    end

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Adresse wurde angelegt'
        format.html { redirect_to address_show_path(@address)}
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        flash[:error] = "Adresse konnte nicht angelegt werden"
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Adresse wurde aktualisiert'
        format.html { redirect_to address_show_path(@address) }
        format.xml  { head :ok }
      else
        flash[:error] = "Adresse konnte nicht aktualisiert werden"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = "Adresse wurde gelöscht"
    respond_to do |format|
      format.html { redirect_to(params[:customerid].blank? ? addresses_path : customer_addresses_path(params[:customer_id])) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy    
  end
  
  private
  def current_address
    if params[:customer_id]
      @address = current_user.addresses.find(params[:id])
    else
      @address = current_user.user_addresses.find(params[:id])
    end
  end

  def address_show_path(address)
    puts params[:customer_id].blank? ? address_path(address) : customer_address_path(params[:customer_id], address) 
    params[:customer_id].blank? ? address_path(address) : customer_address_path(params[:customer_id], address) 
  end
end
