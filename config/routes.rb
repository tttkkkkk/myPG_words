Rails.application.routes.draw do

  get  '/about',   to: 'word#about'
  get  '/search',   to: 'word#search'

  put  '/study_rails',   to: 'word#study_rails'
  put  '/study_docker',  to: 'word#study_docker'
  put  '/study',         to: 'word#study'

  root 'word#home'
  resources :word do
    member do

      put 'study_upd_add'
      put 'study_upd_mns'
      put 'study_next'
      put 'study_back'

      put 'upd_add'
      put 'upd_mns'
      delete 'del_all'
    end
  end

end
