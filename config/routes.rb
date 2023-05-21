Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "real_estates#index"

  get 'real-estates/types', to: 'real_estate_types#index'
  post 'real-estates/types/add', to: 'real_estate_types#create'
  put 'real-estates/types/update/:id', to: 'real_estate_types#update'
  delete 'real-estates/types/delete/:id', to: 'real_estate_types#destroy'

  get 'real-estates', to: 'real_estates#index'
  get 'real-estates/:id', to: 'real_estates#show'
  post 'real-estates/add', to: 'real_estates#create'
  put 'real-estates/update/:id', to: 'real_estates#update'
  delete 'real-estates/delete/:id', to: 'real_estates#destroy'
  get 'real-estates/content/:id', to: 'real_estates#content'
end

