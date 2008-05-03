class AddressesController < ApplicationController
  def index
    if params[:customer_id]
      @addresses = current_user.customers.find(params[:customer_id], :include => :addresses).addresses
    else
      @addresses = current_user.addresses
    end

    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @addresses }
    end
  end

  def show
    @address = Address.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @address }
    end
  end

  def new
    @address = Address.new
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @address }
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    if params[:customer_id]
      @address = current_user.customers.find(params[:customer_id]).addresses.new
    else
      @address = current_user.addresses.new(params[:address])
    end

    respond_to do |format|
      if @address.save
        flash[:notice] = 'Address was successfully created.'
        format.html { redirect_to(@address) }
        format.xml  { render :xml => @address, :status => :created, :location => @address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @address = Address.find(params[:id])

    respond_to do |format|
      if @address.update_attributes(params[:address])
        flash[:notice] = 'Address was successfully updated.'
        format.html { redirect_to(@address) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @address.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy

    respond_to do |format|
      format.html { redirect_to(admin_addresses_url) }
      format.xml  { head :ok }
    end
  end
  
end
