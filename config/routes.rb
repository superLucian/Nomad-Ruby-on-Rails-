Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '/student-loans', to: 'home#student_loans'  
  get '/student-loan-refinancing', to: 'home#student_loan_refinancing'  
  get '/insurance', to: 'home#insurance'
  get '/health-insurance', to:'home#health_insurance'
  get '/renters-insurance', to:'home#renters_insurance' 
  get '/travelers-insurance', to:'home#travelers_insurance' 
  get '/auto-loans', to: 'home#auto_loans' 
  get '/credit-cards', to: 'home#credit_cards'
  get '/personal-loans', to: 'home#personal_loans'
  get '/partners', to: 'home#partners'  
  get '/ofx', to: 'home#ofx'  
  get '/faq', to: 'home#faq'
  get '/about-us', to: 'home#about_us'
  get '/support', to: 'home#support'
  get '/how-it-works', to: 'home#how_it_works'
  get '/jobs', to: 'home#jobs'

  get '/users/sign_up_2', controller: 'devise/registrations', action: 'new'
  get '/users/sso', to: 'users#sso'

  get '/contact-us', to: 'home#contact_us'

  get '/sign_out', to: 'users#sign_out_with_discourse'

  get '/privacy', to: 'home#privacy', :format => 'pdf', :as => 'privacy'
  get '/jobs_pdf', to: 'home#jobs_pdf', :format => 'pdf', :as => 'jobs_pdf'

  get '/terms', to: 'home#terms', :as => 'terms'

  post '/leads', to: 'leads#create'

  resources :users, except: [:index, :destroy]
  resources :applications, except: [:index, :destroy, :show]

  get '/applications/:application_type/new', to: 'applications#new', as: 'new_application_type'
  get '/applications/:id/confirmation', to: 'applications#preview', as: 'preview'
  post '/applications/:id/confirmation', to: 'applications#confirm', as: 'confirm'
  get '/applications/:id/like', to: 'applications#like', as: 'like'
  get '/applications/:id/offer_clicked', to: 'applications#offer_clicked', as: 'offer_clicked'
  get '/applications/:id/offers', to: 'applications#offers', as: 'offers'


  post '/contact_messages', to: 'home#contact_messages'
  
  get '/options', to: 'users#likely_offers', as: 'likely_offers'

  post '/users/:id/interests', to: 'applications#create_interest', as: 'create_interest'
  get '/users/:id/interests', to: 'applications#create_interest'


  get '/dashboard', to: 'users#show'
  get "sitemap.xml" => "home#sitemap", :format => "xml", :as => :sitemap
  get "video_sitemap.xml" => "home#video_sitemap", :format => "xml", :as => :video_sitemap
  get "blog_sitemap.xml" => "home#blog_sitemap", :format => "xml", :as => :blog_sitemap


  require 'resque/server'

  # Of course, you need to substitute your application name here, a block
  # like this probably already exists.
  mount Resque::Server.new, at: "/resque"

end
