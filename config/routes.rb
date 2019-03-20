Rails.application.routes.draw do
  scope '/api' do
    namespace :v1 do
      resources :tasks
      resources :tags
    end
  end
  match '*path' => 'v1/route_errors#error_404', via: :all
end