Rails.application.routes.draw do
  resources :aggregate_downloads
  resources :podcasts
  resources :downloads do
    collection do
      get 'report'
    end
  end
  resources :episodes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
