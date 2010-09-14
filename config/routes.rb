Svspel::Application.routes.draw do
  match "/generate", :to => "document#generate"
  
  resources :games do
    collection do
      get :statistics, :statistics
    end
  end
  
  
  root :to => "svspel#index"
end
