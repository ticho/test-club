Rails.application.routes.draw do
  resources :users, :sessions
  get 'static_pages/club_page', to: 'static_pages#club', as: 'club'
  root 'static_pages#index'
end
