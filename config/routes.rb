require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end
  mount Sidekiq::Web, at: "/sidekiq"

  constraints(lambda { |req| req.format == :json }) do
    resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: %i[create index]
    resource :session, only: %i[create destroy]
    resources :comments, only: :create
    resource :preference, only: %i[show update] do
      patch :mail, on: :collection
    end
  end

  # Defines the root path route ("/")
   #root 'articles#index'
   mount ::Voom::Presenters::WebClient::App, at: '/'
end
