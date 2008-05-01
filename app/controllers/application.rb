# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'a0b0bf62ef025256616451c500efdba2'

  # overwrite if you want to have some login or multi-user environment
  def current_user
    @current_user ||= User.find :first
  end
  helper_method :current_user
end
