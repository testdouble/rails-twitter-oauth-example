Rails.application.routes.draw do
  get "/twitter_authorizations/callback", to: "twitter_authorizations#callback"
  resources :twitter_authorizations

  resources :toots

  root "toots#index"
end
