class InvoicesController < ApplicationController

  before_filter :current_invoice, :only => [:show, :edit, :update, :destroy, :confirm_destroy]

  require 'fpdf'
  load 'fpdf_table.rb'
  load 'fpdf_invoice.rb'
  require 'iconv'
  
  def index
    if params[:search]
      @invoices = current_user.invoices.find :all, :conditions => ['title LIKE ?', "%#{params[:search]}%"], :include => [:receiver_address]
    else
      @invoices = current_user.invoices.find :all, :include => [:receiver_address]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        filename  = (@invoice.formated_number+"_"+@invoice.title+".pdf").downcase.gsub(" ", "_")
        send_data gen_invoice_pdf, :filename => filename, :type => "application/pdf"
      end
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  def new
    @invoice = current_user.invoices.new(:number => Invoice.count + 1, :billing_date => Date.today)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invoice }
    end
  end

  def edit
  end

  def create
    @invoice = current_user.invoices.new(params[:invoice])
    if params[:items].nil?
      flash[:error] = "Es wurden keine Rechnungsposten angegeben"
      render :action => :new and return
    end
    params[:items].each do |item_id, item_attributes|
      @invoice.items << Item.new(item_attributes)
    end

    respond_to do |format|
      if @invoice.save
        flash[:notice] = 'Rechnung wurde angelegt'
        format.html { redirect_to(@invoice) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        flash[:error] = "Rechnung konnte nicht angelegt werden"
        counter = Time.now.to_i
        @invoice.items.each do |item|
          # necessary to give each item a unique id and to have many of them in the form
          item.id = counter+1
          counter += 1
        end
        
        format.html { render :action => "new" and return }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    params[:items].each do |item_id, item_attributes|
      item = @invoice.items.find_by_id(item_id)
      if item
        item.update_attributes(item_attributes)
      else
        @invoice.items << @invoice.items.create(item_attributes)
      end
    end

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Rechnung wurde aktualisiert'
        format.html { redirect_to(@invoice) }
        format.xml  { head :ok }
      else
        flash[:errror] = "Rechnung konnte nicht aktualisiert werden"
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy
    flash[:notice] = "Rechnung wurde gelöscht"
    respond_to do |format|
      format.html { redirect_to(invoices_path) }
      format.xml  { head :ok }
    end
  end
  
  def confirm_destroy
  end

  private
  def current_invoice
    begin
      @invoice = current_user.invoices.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      flash[:error] = "Rechnung wurde nicht gefunden"
      redirect_to invoices_url and return
    end
    
  end
  
  # generates PDF for given invoice
  # see /lib/fpdf/fpdf_invoice.rb + fpdf_table for details
  # :TODO: Add Meta-Info from Invoice to PDF (Author etc.)
  def gen_invoice_pdf
    pdf = FPDF.new
    pdf.extend(FPDF_INVOICE)
    pdf.extend(Fpdf::Table)
    pdf.extend(ApplicationHelper)
    pdf.extend(ActionView::Helpers::NumberHelper)
    pdf.AddFont('vera')
    pdf.AddFont('verab')
    pdf.AddPage('', @invoice)
    pdf.BuildInvoice(@invoice)
    pdf.Output
  end

end

