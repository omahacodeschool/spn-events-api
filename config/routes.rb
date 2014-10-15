SpEventApi::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'all_events' => 'events#all_events'
      get 'spn_events' => 'events#spn_events'
    end
  end
end
