Rails.application.routes.draw do

  devise_for :users


  resources :session_attachments

  post '/photo_sessions/search_session'
  resources :marks do
    collection do
      post :createOrUpdate
      post :find_unmarked
    end
  end 
  resources :session_statuses do 
    collection do 
      post :finish_session
    end
  end
  resources :photo_sessions do 
    collection do 
      post :generate_txt
      get :session_assessment 
      get :session_description 
      post :upload_session
    end
  end


  resources :points do 
    collection do 
      post :find_mark
    end 
  end
  resources :checkboxs
  root 'photo_sessions#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
