Rails.application.routes.draw do

  get  '/about',   to: 'word#about'
  root 'word#home'
  resources :word

end
