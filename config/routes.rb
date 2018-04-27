Rails.application.routes.draw do
  resources :aggregate_downloads do
    collection do
      get 'report'
    end
  end

  resources :podcasts

  resources :downloads do
    collection do
      get 'report'
    end
  end

  resources :episodes
end
