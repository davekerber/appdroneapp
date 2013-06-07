Appdroneapp::Application.routes.draw do
  get "drones/get_drones"

  #root to: 'app_template#about'
  root to: redirect('/new')
  get :new, to: 'ember#new'
  get :drones, to: 'drones#get_drones'
  post :build, to: 'app_template#build'
  get '/:uuid(.:format)', to: 'app_template#show', as: :app_template
end
