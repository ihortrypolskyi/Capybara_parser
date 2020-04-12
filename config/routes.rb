Rails.application.routes.draw do
  root to: 'pages#home'
  get 'parse_site', to: 'pages#parse_site'
end
