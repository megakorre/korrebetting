class SvspelController < ApplicationController  
  
  def index
    if not session[:authenticated]
      redirect_to :login
    end
  end
end
