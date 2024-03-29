# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  #before_action :ssl_required, :only => [ :new, :create, :destroy]

  # render new.erb.html
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = true #old (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      #convert any carts to this user's id
      @cart = Cart.find_by_session_id(request.session_options[:id])
      if @cart
        @cart.user = user
        @cart.save
      end
      redirect_back_or_default('/cart/show')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
