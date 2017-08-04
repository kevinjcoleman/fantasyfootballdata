Rails.application.routes.draw do
  get 'roster/:team_id', to: 'roster#show', as: 'roster'

  get 'user_teams/index'

  get 'user_teams/show'

  get 'sessions/create'

  root 'pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/yahoo/logout' => 'sessions#destroy', :as => :yahoo_logout
end
