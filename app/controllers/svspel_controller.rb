class SvspelController < ApplicationController  
  
  def index
    if session[:authenticated] == nil or session[:authenticated] == false 
      redirect_to :login
    end
  end
end
