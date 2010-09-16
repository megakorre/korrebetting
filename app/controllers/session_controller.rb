class SessionController < ApplicationController
  def new
  end
  
  def create
    username = params[:username]
    password = params[:password]
    
    if username == "deek" and password == "deektest"
      session[:authenticated] = true
      redirect_to "/"
    else
      redirect_to :login
    end
  end
end
