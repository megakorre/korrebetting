Svspel::Application.routes.draw do
  match "/login", :to => "session#new" , :as => :login
  
  
  resources :session
  resources :games do
    collection do
      post :statistics, :statistics
    end
  end
  
  
  root :to => "svspel#index"
end
