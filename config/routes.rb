Rails.application.routes.draw do
  root to: 'checkrs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   resources :checkrs
   post '/', to: 'checkrs#create', as: 'post_checkr'
   
end
