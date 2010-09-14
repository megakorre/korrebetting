class DocumentController < ApplicationController
  respond_to :xls
  
  def generate
    respond_with [{ 
      :matches => [1,2,3]
    }]
  end
end
