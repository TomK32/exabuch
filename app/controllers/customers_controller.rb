class CustomersController < ApplicationController
  def index
    if params[:search]
      @customers = current_user.customers.find :all, :conditions => ['name LIKE ?', "%#{params[:search]}%"]
    else
      unless read_fragment({:id => current_user.id})
        @customers = current_user.customers.find :all
      end
    end
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @customers }
    end
  end

  def show
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def new
    @customer = current_user.customers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @customer }
    end
  end

  def edit
    @customer = current_user.customers.find(params[:id])
  end

  def create
    @customer = current_user.customers.new(params[:customer])

    respond_to do |format|
      if @customer.save
        flash[:notice] = 'Kunde wurde erfolgreich erstellt'
        format.html { redirect_to(@customer) }
        format.xml  { render :xml => @customer, :status => :created, :location => @customer }
      else
        flash[:error] = "Kunde konnte nicht angelegt werden"
        format.html { render :action => "new" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @customer = current_user.customers.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        flash[:notice] = 'Kunde wurde gespeichert.'
        format.html { redirect_to(@customer) }
        format.xml  { head :ok }
      else
        flash[:error] = "Kunde konnte nicht gespeichert werden"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @customer.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer = current_user.customers.find(params[:id])
    @customer.destroy

    respond_to do |format|
      flash[:notice] = "Kunde wurde gelöscht"
      format.html { redirect_to(admin_customers_url) }
      format.xml  { head :ok }
    end
  end
end
