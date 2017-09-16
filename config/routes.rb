Rails.application.routes.draw do
  mount Delayed::Web::Engine, at: '/jobs'
  get 'league_players/index'

  get 'league_players/show'
  get 'players/duplicates', to: 'players#duplicates', as: 'duplicates'
  get 'players/yahoo_duplicates', to: 'players#yahoo_duplicates', as: 'yahoo_duplicates'

  get 'players/merge', to: 'players#merge', as: 'merge'
  resources :players do
    get 'seasons', to: 'player_season#index', as: 'seasons'
  end

  resources :leagues, only: [:show] do
    resources :drafts, controller: 'league_drafts', only: [:destroy, :create]
    resources :players, controller: 'league_players'
  end

  resources :league_team, controller: 'league_team', only: [:show]

  get 'roster/:team_id', to: 'roster#show', as: 'roster'

  get 'user_teams/index'

  get 'user_teams/:id', to: 'user_teams#show', as: 'team'

  get 'sessions/create'

  get 'dev_sign_in', to: 'sessions#sign_in_on_dev', as: 'dev_sign_in'
  root 'pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/yahoo/logout' => 'sessions#destroy', :as => :yahoo_logout
end
