class InvoicesController < ApplicationController

  require 'fpdf'
  load 'fpdf_table.rb'
  load 'fpdf_invoice.rb'
  require 'iconv'
  
  def index
    if params[:search]
      @invoices = current_user.invoices.find :all, :conditions => ['title LIKE ?', "%#{params[:search]}%"]
    else
      @invoices = current_user.invoices.find :all, :include => [:receiver_address]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  def show
    @invoice = current_user.invoices.find(params[:id])

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
    @invoice = current_user.invoices.find(params[:id])
  end

  def create
    @invoice = current_user.invoices.new(params[:invoice])
    if params[:items].nil?
      flash[:error] = "Es wurden keine Rechnungsposten angegeben"
      render :action => :new and return
    end
    params[:items].each do |item_id, item_attributes|
      @invoice.items.create(item_attributes)
    end

    respond_to do |format|
      if @invoice.save
        flash[:notice] = 'Invoice was successfully created.'
        format.html { redirect_to(@invoice) }
        format.xml  { render :xml => @invoice, :status => :created, :location => @invoice }
      else
        flash[:error] = "Rechnung konnte nicht erstellt werden"
        format.html { render :action => "new" and return }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @invoice = current_user.invoices.find(params[:id])
    params[:items].each do |item_id, item_attributes|
      item = @invoice.items.find_by_id(item_id)
      if item
        item.update_attributes(item_attributes)
      else
        @invoice.items.create(item_attributes)
      end
    end

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        flash[:notice] = 'Invoice was successfully updated.'
        format.html { redirect_to(@invoice) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invoice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice = current_user.invoices.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to(admin_invoices_url) }
      format.xml  { head :ok }
    end
  end
  
  private
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

