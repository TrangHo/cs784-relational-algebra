class SessionsController < ApplicationController

  def new
  end

  def create
    admin = Admin.find_by(username: params[:session][:username].downcase)
    if admin && admin.authenticate(params[:session][:password])
      log_in admin
      redirect_to problems_url
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
