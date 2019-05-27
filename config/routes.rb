Rails.application.routes.draw do

  get  '/about',   to: 'word#about'
  root 'word#home'
  resources :word do
    member do
      put 'study'
      put 'upd_add'
      put 'upd_mns'
      delete 'del_all'
    end
  end

end
