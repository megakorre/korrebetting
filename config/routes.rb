Svspel::Application.routes.draw do
  match "/login", :to => "session#new" , :as => :login
  match "/logout", :to => 'session#logout', :as => :logout
  
  match "/document", :to => "games#document"
  resources :session
  resources :games do
    collection do
      get :statistics, :statistics
    end
  end  
  root :to => "svspel#index"
end
