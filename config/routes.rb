Rails.application.routes.draw do
  resources :players do
    get 'seasons', to: 'player_season#index', as: 'seasons'
  end


  get 'roster/:team_id', to: 'roster#show', as: 'roster'

  get 'user_teams/index'

  get 'user_teams/:id', to: 'user_teams#show', as: 'team'

  get 'sessions/create'

  root 'pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/yahoo/logout' => 'sessions#destroy', :as => :yahoo_logout
end
