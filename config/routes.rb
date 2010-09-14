Svspel::Application.routes.draw do
  
  resources :games do
    collection do
      get :statistics, :statistics
    end
  end
  
  
  root :to => "svspel#index"
end
