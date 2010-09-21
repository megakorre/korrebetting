class SessionController < ApplicationController
  def new
  end
  
  def logout
    session[:authenticated] = nil
    redirect_to :root
  end
  
  def create
    username = params[:username]
    password = params[:password]
    
    if username == "deek" and password == "deektest"
      session[:authenticated] = true
      redirect_to :root
    else
      redirect_to :login
    end    
  end
end
