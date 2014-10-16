SpEventApi::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'all_events' => 'events#all_events'
      get 'spn_events' => 'events#spn_events'
      get 'tech_omaha_events' => 'events#tech_omaha_events'
      get 'startup_lincoln_events' => 'events#startup_lincoln_events'
    end
  end
end
