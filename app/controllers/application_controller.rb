class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def require_admin
    unless current_admin
      flash[:warning] = "Unauthorized to access the page!"
      redirect_to root_path
    end
  end
end
