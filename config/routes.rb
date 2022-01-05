Rails.application.routes.draw do
  root'static_pages#home'
  get '/signup', to: 'users#new'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/about', to: 'static_pages#about'
  scope "(:locale)", locale: /en|vi/ do
  end
end
