Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'user/registrations'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # HomePage
  get '/', to: 'application#home'
end
