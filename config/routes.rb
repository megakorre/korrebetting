Svspel::Application.routes.draw do
  
  resources :games do
    collection do
      get :rename, :rename
    end
  end
  
  
  root :to => "svspel#index"
end
