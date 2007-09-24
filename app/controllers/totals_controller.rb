class TotalsController < ApplicationController

  layout "frontend"
	active_scaffold :total do |config|
    config.columns = [:tax]
	end
  
end
