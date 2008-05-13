class ItemsController < ApplicationController
  def new
    @item = Item.new

    respond_to do |format|
      format.js do
        # necessary to give each item a unique id and to have many of them in the form
        @item = Item.new()
        @item.id = Time.now.to_i
      end
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end
end
