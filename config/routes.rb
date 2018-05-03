Rails.application.routes.draw do
  resources :downloads do
    collection do
      get 'report'
    end
  end

  resources :podcasts
  resources :episodes

  root to: 'downloads#report'
end
